# Supabase

Aqui viven las migraciones SQL y las funciones necesarias para el backend.

Proyecto conectado: **Examenes** (organizacion `Anzi`, ref `sdkacefvpppvufkfzolb`, region `eu-west-1`). La URL y la clave publica ya estan en `.env.local` (no versionado); para volver a vincular la CLI usa `supabase link --project-ref sdkacefvpppvufkfzolb` con un access token de cuenta (`supabase login` o `SUPABASE_ACCESS_TOKEN`).

## Migraciones

1. `0001_initial_schema.sql` - categorias, perfiles (con `username` para el login), tests, preguntas, intentos y respuestas.
2. `0002_row_level_security.sql` - RLS en todas las tablas; `questions` solo es consultable directamente por administradores.
3. `0003_ranking_views.sql` - vistas `test_rankings`, `category_rankings` y `general_rankings`.
4. `0004_test_taking_functions.sql` - `get_test_questions()` (preguntas sin `correct_options`) y `submit_attempt()` (corrige y guarda el intento en el servidor).

Aplicar en orden con `supabase db push` o pegando el contenido en el SQL editor del proyecto.

## Contenido (seed)

`seed/` guarda el SQL generado por `scripts/import-questions.mjs` a partir de un CSV con el formato de `content/plantilla_preguntas.csv` (categorias que falten + `tests` + `questions`). Se aplica despues de las 4 migraciones. Ver la seccion "De la plantilla al SQL" del README principal para el comando exacto.

## Decisiones tomadas

- Los participantes inician sesion con **usuario**, no con email. `profiles.username` guarda el nombre visible para el login y Supabase Auth almacena un email sintetico `<username>@participants.local`. Los usuarios los crea un administrador (no hay auto-registro).
- Un participante solo puede enviar **un intento por test** (`unique (test_id, user_id)` en `test_attempts`). Si el profesor quiere permitir reintentos, hay que revisar esta restriccion y la funcion `submit_attempt`.
- Las clasificaciones (`*_rankings`) son vistas propiedad del rol de migracion, por lo que no aplican las politicas RLS de "solo mis propios intentos": muestran datos agregados de todos los participantes a proposito.

## Pendiente

- Decidir si se ocultan las clasificaciones mientras un test sigue abierto (`tests.ends_at`).
- Script de alta de usuarios (usa la `service_role` key desde un entorno seguro, nunca desde el navegador) para crear cuentas en `auth.users` + fila en `profiles` a partir de una lista del profesor. De momento hay 2 usuarios de prueba creados a mano (`test23`/`test89`, categorias `2-3`/`8-9`) solo para verificar el flujo.
- Cargar contenido real de preguntas por categoria (hoy solo esta el ejemplo de 1 Samuel 1).
