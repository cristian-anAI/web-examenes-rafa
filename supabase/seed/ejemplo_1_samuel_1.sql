-- Generado automaticamente por scripts/import-questions.mjs
-- Aplicar DESPUES de las migraciones de supabase/migrations (0001 a 0004).
-- Revisa los rangos de edad de las categorias nuevas antes de ejecutar en produccion.

begin;

-- Categorias (se crean solo si no existen ya) --
insert into public.age_categories (name, min_age, max_age)
select $$2-3$$, 2, 3
where not exists (select 1 from public.age_categories where name = $$2-3$$);

insert into public.age_categories (name, min_age, max_age)
select $$8-9$$, 8, 9
where not exists (select 1 from public.age_categories where name = $$8-9$$);

-- Tests y preguntas --

-- Test: "1 Samuel - Capitolul 1" (categoria: 2-3) - 10 preguntas
with new_test as (
  insert into public.tests (category_id, title, is_published)
  values (
    (select id from public.age_categories where name = $$2-3$$),
    $$1 Samuel - Capitolul 1$$,
    true
  )
  returning id
)
insert into public.questions (test_id, position, question_type, prompt, options, correct_options)
select new_test.id, v.position, v.question_type::public.question_type, v.prompt, v.options::jsonb, v.correct_options::jsonb
from new_test, (values
  (1, 'single_choice', $$Cum se numea barbatul din Ramataim-Tofim?$$, $$[{"id":"a","label":"Eli"},{"id":"b","label":"Elcana"},{"id":"c","label":"Saul"}]$$, $$["b"]$$),
  (2, 'single_choice', $$Cum se numea sotia lui Elcana care nu avea copii?$$, $$[{"id":"a","label":"Ana"},{"id":"b","label":"Penina"},{"id":"c","label":"Maria"}]$$, $$["a"]$$),
  (3, 'single_choice', $$Cine avea copii, spre deosebire de Ana?$$, $$[{"id":"a","label":"Penina"},{"id":"b","label":"Ana"},{"id":"c","label":"Elisabeta"}]$$, $$["a"]$$),
  (4, 'single_choice', $$Unde mergea Elcana in fiecare an ca sa se inchine si sa aduca jertfe Domnului?$$, $$[{"id":"a","label":"Ierusalim"},{"id":"b","label":"Betleem"},{"id":"c","label":"Silo"}]$$, $$["c"]$$),
  (5, 'single_choice', $$Cum se purta Penina cu Ana?$$, $$[{"id":"a","label":"O incuraja"},{"id":"b","label":"O necajea"},{"id":"c","label":"O ajuta sa se roage"}]$$, $$["b"]$$),
  (6, 'single_choice', $$Ce a facut Ana cand era foarte mahnita?$$, $$[{"id":"a","label":"S-a rugat Domnului"},{"id":"b","label":"A plecat de acasa"},{"id":"c","label":"S-a certat cu Penina"}]$$, $$["a"]$$),
  (7, 'single_choice', $$De ce a crezut Eli ca Ana este beata?$$, $$[{"id":"a","label":"Pentru ca Ana vorbea foarte tare"},{"id":"b","label":"Pentru ca Ana se clatina"},{"id":"c","label":"Pentru ca doar buzele i se miscau, iar glasul nu i se auzea"}]$$, $$["c"]$$),
  (8, 'single_choice', $$Ce i-a raspuns Ana lui Eli cand acesta a mustrat-o?$$, $$[{"id":"a","label":"Ca este o femeie necajita si ca isi varsa sufletul inaintea Domnului"},{"id":"b","label":"Ca Penina a facut-o sa planga"},{"id":"c","label":"Ca Elcana a trimis-o sa se roage"}]$$, $$["a"]$$),
  (9, 'single_choice', $$Ce s-a schimbat la Ana dupa ce Eli i-a vorbit?$$, $$[{"id":"a","label":"A inceput sa planga si mai mult"},{"id":"b","label":"A plecat, a mancat si fata ei nu a mai fost trista"},{"id":"c","label":"A hotarat sa nu mai mearga la Silo"}]$$, $$["b"]$$),
  (10, 'single_choice', $$Dupa ce Samuel a fost intarcat, unde l-a dus Ana?$$, $$[{"id":"a","label":"La casa lui Eli, la Silo"},{"id":"b","label":"La Ierusalim"},{"id":"c","label":"La casa lui Elcana din Ramataim"}]$$, $$["a"]$$)
) as v(position, question_type, prompt, options, correct_options);

-- Test: "1 Samuel - Capitolul 1" (categoria: 8-9) - 3 preguntas
with new_test as (
  insert into public.tests (category_id, title, is_published)
  values (
    (select id from public.age_categories where name = $$8-9$$),
    $$1 Samuel - Capitolul 1$$,
    true
  )
  returning id
)
insert into public.questions (test_id, position, question_type, prompt, options, correct_options)
select new_test.id, v.position, v.question_type::public.question_type, v.prompt, v.options::jsonb, v.correct_options::jsonb
from new_test, (values
  (1, 'single_choice', $$Care era ordinea corecta a numelor din familia lui Elcana, asa cum apar in inceputul capitolului?$$, $$[{"id":"a","label":"Elcana - Ieroham - Elihu - Tohu - Tuf"},{"id":"b","label":"Elcana - Tohu - Elihu - Ieroham - Tuf"},{"id":"c","label":"Elcana - Elihu - Tohu - Ieroham - Tuf"}]$$, $$["a"]$$),
  (2, 'single_choice', $$Care era diferenta dintre Ana si Penina?$$, $$[{"id":"a","label":"Ana era sotia mai tanara, iar Penina era slujitoarea lui Elcana"},{"id":"b","label":"Ana nu avea copii, iar Penina avea fii si fiice"},{"id":"c","label":"Ana locuia la Silo, iar Penina la Ramataim"}]$$, $$["b"]$$),
  (3, 'single_choice', $$De ce ii dadea Elcana Anei o parte aleasa din jertfa?$$, $$[{"id":"a","label":"Pentru ca era cea mai in varsta dintre sotiile lui"},{"id":"b","label":"Pentru ca Ana avea mai multi copii"},{"id":"c","label":"Pentru ca o iubea, desi Domnul o facuse stearpa"}]$$, $$["c"]$$)
) as v(position, question_type, prompt, options, correct_options);

commit;
