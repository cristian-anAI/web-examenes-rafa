#!/usr/bin/env node
// Convierte una hoja de preguntas (plantilla content/plantilla_preguntas.csv) en el
// SQL necesario para crear las categorias que falten y los tests/questions reales
// en Supabase.
//
// Uso:
//   node scripts/import-questions.mjs <entrada.csv> [salida.sql] [--draft]
//
// --draft crea los tests con is_published = false (por defecto se publican).
//
// El SQL generado se pega en el SQL editor de Supabase o se ejecuta con
// `supabase db execute` / `psql`. Debe aplicarse DESPUES de las migraciones de
// supabase/migrations.

import { readFileSync, writeFileSync } from 'node:fs'
import path from 'node:path'

const OPTION_LETTERS = ['a', 'b', 'c', 'd', 'e', 'f']
const DIFFICULTIES = ['facil', 'medio', 'dificil']
const TYPE_MAP = {
  verdadero_falso: 'true_false',
  unica: 'single_choice',
  multiple: 'multiple_choice',
}

function fail(message) {
  console.error(`Error: ${message}`)
  process.exit(1)
}

function parseCsv(text) {
  const rows = []
  let row = []
  let field = ''
  let inQuotes = false
  // Parseo caracter a caracter para soportar comillas con comas/saltos de linea dentro.
  for (let i = 0; i < text.length; i += 1) {
    const char = text[i]
    if (inQuotes) {
      if (char === '"') {
        if (text[i + 1] === '"') {
          field += '"'
          i += 1
        } else {
          inQuotes = false
        }
      } else {
        field += char
      }
      continue
    }

    if (char === '"') {
      inQuotes = true
    } else if (char === ',') {
      row.push(field)
      field = ''
    } else if (char === '\r') {
      // ignorado, el \n que le sigue cierra la fila
    } else if (char === '\n') {
      row.push(field)
      rows.push(row)
      row = []
      field = ''
    } else {
      field += char
    }
  }
  if (field.length > 0 || row.length > 0) {
    row.push(field)
    rows.push(row)
  }
  return rows.filter((r) => r.length > 1 || r[0] !== '')
}

function sqlDollarQuote(value) {
  if (value.includes('$$')) {
    fail(`El texto "${value}" contiene "$$", que no se puede escapar con este script.`)
  }
  return `$$${value}$$`
}

function loadRows(csvPath) {
  const text = readFileSync(csvPath, 'utf8').replace(/^\uFEFF/, '')
  const table = parseCsv(text)
  if (table.length < 2) fail('El CSV no tiene filas de datos.')
  const header = table[0].map((h) => h.trim())
  const required = ['categoria', 'test', 'orden', 'tipo', 'pregunta', 'correctas']
  for (const col of required) {
    if (!header.includes(col)) fail(`Falta la columna "${col}" en el CSV.`)
  }
  return table.slice(1).map((cols, index) => {
    const record = {}
    header.forEach((name, i) => {
      record[name] = (cols[i] ?? '').trim()
    })
    record.__line = index + 2 // +1 por el encabezado, +1 por indice base 1
    return record
  })
}

function buildQuestion(record) {
  const line = record.__line
  const questionType = TYPE_MAP[record.tipo]
  if (!questionType) {
    fail(`Linea ${line}: tipo "${record.tipo}" desconocido (usa verdadero_falso, unica o multiple).`)
  }

  const options = []
  for (const letter of OPTION_LETTERS) {
    const value = record[`opcion_${letter}`]
    if (value) options.push({ id: letter, label: value })
  }
  if (options.length < 2) {
    fail(`Linea ${line}: la pregunta necesita al menos 2 opciones rellenadas.`)
  }

  const correctLetters = record.correctas
    .split(',')
    .map((s) => s.trim().toLowerCase())
    .filter(Boolean)
  if (correctLetters.length === 0) {
    fail(`Linea ${line}: falta la columna "correctas".`)
  }
  const validIds = new Set(options.map((o) => o.id))
  for (const letter of correctLetters) {
    if (!validIds.has(letter)) {
      fail(`Linea ${line}: "correctas" usa "${letter}" pero opcion_${letter} esta vacia.`)
    }
  }

  if (questionType === 'true_false') {
    if (options.length !== 2 || options[0].id !== 'a' || options[1].id !== 'b') {
      fail(`Linea ${line}: verdadero_falso solo debe rellenar opcion_a y opcion_b.`)
    }
    if (correctLetters.length !== 1) {
      fail(`Linea ${line}: verdadero_falso debe tener exactamente una respuesta correcta.`)
    }
  }
  if (questionType === 'single_choice' && correctLetters.length !== 1) {
    fail(`Linea ${line}: "unica" debe tener exactamente una respuesta correcta.`)
  }

  const position = Number.parseInt(record.orden, 10)
  if (!Number.isInteger(position) || position < 1) {
    fail(`Linea ${line}: "orden" debe ser un numero entero positivo.`)
  }

  return {
    position,
    questionType,
    prompt: record.pregunta,
    options,
    correctOptions: correctLetters,
  }
}

function guessAgeRange(categoryName) {
  const match = categoryName.match(/^(\d+)\s*-\s*(\d+)$/)
  if (match) return { minAge: Number(match[1]), maxAge: Number(match[2]) }
  const overMatch = categoryName.match(/^\+(\d+)$/)
  if (overMatch) return { minAge: Number(overMatch[1]) + 1, maxAge: 120 }
  return null
}

function generateSql(records, { publish }) {
  const categories = new Map() // name -> { minAge, maxAge } | null
  const tests = new Map() // "categoria|||test" -> { categoria, test, questions: [] }

  for (const record of records) {
    if (!record.categoria || !record.test) continue // ignora filas en blanco

    if (!categories.has(record.categoria)) {
      categories.set(record.categoria, guessAgeRange(record.categoria))
    }

    const difficulty = record.nivel || 'facil'
    if (!DIFFICULTIES.includes(difficulty)) {
      fail(`Linea ${record.__line}: nivel "${difficulty}" desconocido (usa facil, medio o dificil).`)
    }

    const key = `${record.categoria}|||${record.test}|||${difficulty}`
    if (!tests.has(key)) {
      tests.set(key, { categoria: record.categoria, test: record.test, difficulty, questions: [] })
    }
    tests.get(key).questions.push(buildQuestion(record))
  }

  for (const group of tests.values()) {
    const seen = new Set()
    for (const q of group.questions) {
      if (seen.has(q.position)) {
        fail(`Test "${group.test}" (${group.categoria}, ${group.difficulty}): la posicion ${q.position} esta repetida.`)
      }
      seen.add(q.position)
    }
  }

  const lines = []
  lines.push('-- Generado automaticamente por scripts/import-questions.mjs')
  lines.push('-- Aplicar DESPUES de todas las migraciones de supabase/migrations.')
  lines.push('-- Revisa los rangos de edad de las categorias nuevas antes de ejecutar en produccion.')
  lines.push('')
  lines.push('begin;')
  lines.push('')

  lines.push('-- Categorias (se crean solo si no existen ya) --')
  for (const [name, range] of categories) {
    const minAge = range ? range.minAge : 0
    const maxAge = range ? range.maxAge : 99
    if (!range) {
      lines.push(`-- AVISO: no se pudo adivinar el rango de edad de "${name}"; ajusta min_age/max_age a mano.`)
    }
    lines.push('insert into public.age_categories (name, min_age, max_age)')
    lines.push(`select ${sqlDollarQuote(name)}, ${minAge}, ${maxAge}`)
    lines.push(`where not exists (select 1 from public.age_categories where name = ${sqlDollarQuote(name)});`)
    lines.push('')
  }

  lines.push('-- Tests y preguntas --')
  for (const group of tests.values()) {
    const sortedQuestions = [...group.questions].sort((a, b) => a.position - b.position)
    lines.push('')
    lines.push(`-- Test: "${group.test}" (categoria: ${group.categoria}, nivel: ${group.difficulty}) - ${sortedQuestions.length} preguntas`)
    lines.push('with new_test as (')
    lines.push('  insert into public.tests (category_id, title, difficulty, is_published)')
    lines.push('  values (')
    lines.push(`    (select id from public.age_categories where name = ${sqlDollarQuote(group.categoria)}),`)
    lines.push(`    ${sqlDollarQuote(group.test)},`)
    lines.push(`    '${group.difficulty}'::public.exam_difficulty,`)
    lines.push(`    ${publish ? 'true' : 'false'}`)
    lines.push('  )')
    lines.push('  returning id')
    lines.push(')')
    lines.push('insert into public.questions (test_id, position, question_type, prompt, options, correct_options)')
    lines.push('select new_test.id, v.position, v.question_type::public.question_type, v.prompt, v.options::jsonb, v.correct_options::jsonb')
    lines.push('from new_test, (values')
    const valueRows = sortedQuestions.map((q, index) => {
      const optionsJson = JSON.stringify(q.options.map((o) => ({ id: o.id, label: o.label })))
      const correctJson = JSON.stringify(q.correctOptions)
      const comma = index === sortedQuestions.length - 1 ? '' : ','
      return `  (${q.position}, '${q.questionType}', ${sqlDollarQuote(q.prompt)}, ${sqlDollarQuote(optionsJson)}, ${sqlDollarQuote(correctJson)})${comma}`
    })
    lines.push(valueRows.join('\n'))
    lines.push(') as v(position, question_type, prompt, options, correct_options);')
  }

  lines.push('')
  lines.push('commit;')
  lines.push('')

  return { sql: lines.join('\n'), categories, tests }
}

function main() {
  const args = process.argv.slice(2)
  const publish = !args.includes('--draft')
  const positional = args.filter((a) => !a.startsWith('--'))
  const inputPath = positional[0]
  if (!inputPath) {
    fail('Uso: node scripts/import-questions.mjs <entrada.csv> [salida.sql] [--draft]')
  }
  const resolvedInput = path.resolve(inputPath)
  const defaultOutput = path.join(
    'supabase',
    'seed',
    `${path.basename(resolvedInput, path.extname(resolvedInput))}.sql`,
  )
  const outputPath = path.resolve(positional[1] ?? defaultOutput)

  const records = loadRows(resolvedInput)
  const { sql, categories, tests } = generateSql(records, { publish })

  writeFileSync(outputPath, sql, 'utf8')

  const questionCount = [...tests.values()].reduce((sum, g) => sum + g.questions.length, 0)
  console.log(`OK: ${outputPath}`)
  console.log(`  Categorias: ${[...categories.keys()].join(', ') || '(ninguna)'}`)
  console.log(`  Tests: ${tests.size}, preguntas: ${questionCount}`)
  console.log(`  is_published: ${publish}`)
}

main()
