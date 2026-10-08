-- Generado automaticamente por scripts/import-questions.mjs
-- Aplicar DESPUES de todas las migraciones de supabase/migrations.
-- Revisa los rangos de edad de las categorias nuevas antes de ejecutar en produccion.

begin;

-- Categorias (se crean solo si no existen ya) --
insert into public.age_categories (name, min_age, max_age)
select $$2-3$$, 2, 3
where not exists (select 1 from public.age_categories where name = $$2-3$$);

insert into public.age_categories (name, min_age, max_age)
select $$4-5$$, 4, 5
where not exists (select 1 from public.age_categories where name = $$4-5$$);

insert into public.age_categories (name, min_age, max_age)
select $$6-7$$, 6, 7
where not exists (select 1 from public.age_categories where name = $$6-7$$);

insert into public.age_categories (name, min_age, max_age)
select $$8-9$$, 8, 9
where not exists (select 1 from public.age_categories where name = $$8-9$$);

insert into public.age_categories (name, min_age, max_age)
select $$10-11$$, 10, 11
where not exists (select 1 from public.age_categories where name = $$10-11$$);

insert into public.age_categories (name, min_age, max_age)
select $$18-35$$, 18, 35
where not exists (select 1 from public.age_categories where name = $$18-35$$);

insert into public.age_categories (name, min_age, max_age)
select $$+35$$, 36, 120
where not exists (select 1 from public.age_categories where name = $$+35$$);

-- Tests y preguntas --

-- Test: "1 Samuel - Capitolul 1-2" (categoria: 2-3, nivel: facil) - 25 preguntas
with new_test as (
  insert into public.tests (category_id, title, difficulty, is_published)
  values (
    (select id from public.age_categories where name = $$2-3$$),
    $$1 Samuel - Capitolul 1-2$$,
    'facil'::public.exam_difficulty,
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
  (10, 'single_choice', $$Dupa ce Samuel a fost intarcat, unde l-a dus Ana?$$, $$[{"id":"a","label":"La casa lui Eli, la Silo"},{"id":"b","label":"La Ierusalim"},{"id":"c","label":"La casa lui Elcana din Ramataim"}]$$, $$["a"]$$),
  (11, 'true_false', $$Elcana avea doua sotii: Ana si Penina$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (12, 'true_false', $$Ana avea mai multi copii decat Penina$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (13, 'true_false', $$Penina o necajea pe Ana pentru ca nu avea copii$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (14, 'true_false', $$Ana s-a rugat Domnului pentru un fiu.$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (15, 'true_false', $$Eli a crezut la inceput ca Ana era beata$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (16, 'true_false', $$Ana i-a spus lui Eli ca nu bause vin sau bautura tare$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (17, 'true_false', $$Samuel a fost crescut de Penina$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (18, 'true_false', $$Ana l-a dus pe Samuel la Casa Domnului dupa ce l-a intarcat$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (19, 'true_false', $$Hofni si Fineas erau fiii lui Eli$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (20, 'true_false', $$Samuel nu a mai slujit Domnului dupa ce a fost adus in Casa Domnului$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (21, 'multiple_choice', $$Care din urmatoarele fraze sunt adevarate?$$, $$[{"id":"a","label":"Ana nu avea copii"},{"id":"b","label":"Penina avea copii"},{"id":"c","label":"Ana s-a rugat Domnului pentru un fiu"}]$$, $$["a","b","c"]$$),
  (22, 'multiple_choice', $$Ce personaje apar in 1 Samuel 1-2?$$, $$[{"id":"a","label":"Ana"},{"id":"b","label":"David"},{"id":"c","label":"Eli"}]$$, $$["a","c"]$$),
  (23, 'multiple_choice', $$Ce s-a intamplat cu Samuel pe masura ce crestea?$$, $$[{"id":"a","label":"Crestea inaintea Domnului"},{"id":"b","label":"Crestea si era placut Domnului si oamenilor"},{"id":"c","label":"Pleca din Silo"}]$$, $$["a","b"]$$),
  (24, 'multiple_choice', $$Ce faceau fiii lui Eli, Hofni si Fineas?$$, $$[{"id":"a","label":"Faceau lucruri rele"},{"id":"b","label":"Il cinsteau pe Dumnezeu in toate"},{"id":"c","label":"Pacatuiau inaintea Domnului"}]$$, $$["a","c"]$$),
  (25, 'multiple_choice', $$Cine il iubea pe Samuel?$$, $$[{"id":"a","label":"Domnul"},{"id":"b","label":"Ana"},{"id":"c","label":"Dumnezeu nu stia de el pentru ca era inca copil"}]$$, $$["a","b"]$$)
) as v(position, question_type, prompt, options, correct_options);

-- Test: "1 Samuel - Capitolul 1-2" (categoria: 4-5, nivel: facil) - 25 preguntas
with new_test as (
  insert into public.tests (category_id, title, difficulty, is_published)
  values (
    (select id from public.age_categories where name = $$4-5$$),
    $$1 Samuel - Capitolul 1-2$$,
    'facil'::public.exam_difficulty,
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
  (10, 'single_choice', $$Dupa ce Samuel a fost intarcat, unde l-a dus Ana?$$, $$[{"id":"a","label":"La casa lui Eli, la Silo"},{"id":"b","label":"La Ierusalim"},{"id":"c","label":"La casa lui Elcana din Ramataim"}]$$, $$["a"]$$),
  (11, 'true_false', $$Elcana avea doua sotii: Ana si Penina$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (12, 'true_false', $$Ana avea mai multi copii decat Penina$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (13, 'true_false', $$Penina o necajea pe Ana pentru ca nu avea copii$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (14, 'true_false', $$Ana s-a rugat Domnului pentru un fiu.$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (15, 'true_false', $$Eli a crezut la inceput ca Ana era beata$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (16, 'true_false', $$Ana i-a spus lui Eli ca nu bause vin sau bautura tare$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (17, 'true_false', $$Samuel a fost crescut de Penina$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (18, 'true_false', $$Ana l-a dus pe Samuel la Casa Domnului dupa ce l-a intarcat$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (19, 'true_false', $$Hofni si Fineas erau fiii lui Eli$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (20, 'true_false', $$Samuel nu a mai slujit Domnului dupa ce a fost adus in Casa Domnului$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (21, 'multiple_choice', $$Care din urmatoarele fraze sunt adevarate?$$, $$[{"id":"a","label":"Ana nu avea copii"},{"id":"b","label":"Penina avea copii"},{"id":"c","label":"Ana s-a rugat Domnului pentru un fiu"}]$$, $$["a","b","c"]$$),
  (22, 'multiple_choice', $$Ce personaje apar in 1 Samuel 1-2?$$, $$[{"id":"a","label":"Ana"},{"id":"b","label":"David"},{"id":"c","label":"Eli"}]$$, $$["a","c"]$$),
  (23, 'multiple_choice', $$Ce s-a intamplat cu Samuel pe masura ce crestea?$$, $$[{"id":"a","label":"Crestea inaintea Domnului"},{"id":"b","label":"Crestea si era placut Domnului si oamenilor"},{"id":"c","label":"Pleca din Silo"}]$$, $$["a","b"]$$),
  (24, 'multiple_choice', $$Ce faceau fiii lui Eli, Hofni si Fineas?$$, $$[{"id":"a","label":"Faceau lucruri rele"},{"id":"b","label":"Il cinsteau pe Dumnezeu in toate"},{"id":"c","label":"Pacatuiau inaintea Domnului"}]$$, $$["a","c"]$$),
  (25, 'multiple_choice', $$Cine il iubea pe Samuel?$$, $$[{"id":"a","label":"Domnul"},{"id":"b","label":"Ana"},{"id":"c","label":"Dumnezeu nu stia de el pentru ca era inca copil"}]$$, $$["a","b"]$$)
) as v(position, question_type, prompt, options, correct_options);

-- Test: "1 Samuel - Capitolul 1-2" (categoria: 6-7, nivel: medio) - 25 preguntas
with new_test as (
  insert into public.tests (category_id, title, difficulty, is_published)
  values (
    (select id from public.age_categories where name = $$6-7$$),
    $$1 Samuel - Capitolul 1-2$$,
    'medio'::public.exam_difficulty,
    true
  )
  returning id
)
insert into public.questions (test_id, position, question_type, prompt, options, correct_options)
select new_test.id, v.position, v.question_type::public.question_type, v.prompt, v.options::jsonb, v.correct_options::jsonb
from new_test, (values
  (1, 'single_choice', $$Din ce cetate era Elcana?$$, $$[{"id":"a","label":"Betleem"},{"id":"b","label":"Rama"},{"id":"c","label":"Ghibea"}]$$, $$["b"]$$),
  (2, 'single_choice', $$Cum se numeau cele doua sotii ale lui Elcana? (1:2)$$, $$[{"id":"a","label":"Ana si Penina"},{"id":"b","label":"Ana si Mical"},{"id":"c","label":"Penina si Abigail"}]$$, $$["a"]$$),
  (3, 'single_choice', $$De ce era mahnita Ana? (1:6-7)$$, $$[{"id":"a","label":"Pentru ca Elcana o ura"},{"id":"b","label":"Pentru ca Penina o batjocorea din cauza faptului ca nu avea copii"},{"id":"c","label":"Pentru ca nu putea merge la Cortul Intalnirii"}]$$, $$["b"]$$),
  (4, 'single_choice', $$Ce i-a promis Ana Domnului daca ii va da un fiu? (1:11)$$, $$[{"id":"a","label":"Ca il va face preot"},{"id":"b","label":"Ca il va trimite la Ierusalim"},{"id":"c","label":"Ca il va inchina Domnului pentru toate zilele vietii lui"}]$$, $$["c"]$$),
  (5, 'single_choice', $$Cine a crezut ca Ana era beata? (1:12-14)$$, $$[{"id":"a","label":"Elcana"},{"id":"b","label":"Eli"},{"id":"c","label":"Penina si Abigail"}]$$, $$["b"]$$),
  (6, 'single_choice', $$Ce i-a raspuns Ana lui Eli cand acesta a intrebat-o de ce este beata? (1:15-16)$$, $$[{"id":"a","label":"Ca era foarte obosita"},{"id":"b","label":"Ca nu bause vin sau bautura tare, ci isi varsa sufletul inaintea Domnului"},{"id":"c","label":"Ca Penina o facuse sa planga"}]$$, $$["b"]$$),
  (7, 'single_choice', $$Ce nume i-a dat Ana fiului ei?$$, $$[{"id":"a","label":"Samuel"},{"id":"b","label":"Saul"},{"id":"c","label":"I-Cabod"}]$$, $$["a"]$$),
  (8, 'single_choice', $$Cand l-a dus Ana pe Samuel la Casa Domnului? (1:24)$$, $$[{"id":"a","label":"Dupa ce l-a intarcat"},{"id":"b","label":"Imediat dupa nastere"},{"id":"c","label":"Cand a implinit 12 ani"}]$$, $$["a"]$$),
  (9, 'single_choice', $$Ce faceau fiii lui Eli cu jertfele aduse Domnului? (2:12-17)$$, $$[{"id":"a","label":"Le imparteau saracilor"},{"id":"b","label":"Luau pentru ei partea care nu era a lor"},{"id":"c","label":"Le ardeau in intregime"}]$$, $$["b"]$$),
  (10, 'single_choice', $$Ce facea Samuel in slujba Domnului? (2:18)$$, $$[{"id":"a","label":"Purta un efod de in si slujea inaintea Domnului"},{"id":"b","label":"Conducea poporul in lupta"},{"id":"c","label":"Aducea singur toate jertfele"}]$$, $$["a"]$$),
  (11, 'true_false', $$Elcana se suia în fiecare an din cetatea lui ca să se închine și să aducă jertfe Domnului. (1:3)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (12, 'true_false', $$Penina avea copii, iar Ana nu avea copii. (1:2)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (13, 'true_false', $$Elcana i-a spus Anei că pentru el valorează mai mult decât zece fii. (1:8)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (14, 'true_false', $$Ana i-a spus lui Eli că este beată pentru că băuse vin. (1:15)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (15, 'true_false', $$După ce s-a rugat, Ana a plecat și fața ei nu mai era aceeași ca înainte. (1:18)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (16, 'true_false', $$Samuel a fost închinat Domnului pentru toate zilele vieții lui. (1:11,28)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (17, 'true_false', $$Elcana a mers cu Ana când aceasta l-a dus pe Samuel la Casa Domnului. (1:24)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (18, 'true_false', $$Fiii lui Eli erau cunoscuți pentru că se temeau foarte mult de Domnul. (2:12)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (19, 'true_false', $$Samuel slujea înaintea Domnului, fiind încă băiat. (2:18)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (20, 'true_false', $$Ana a mai avut trei fii și două fiice după Samuel. (2:21)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (21, 'multiple_choice', $$Care dintre urmatoarele lucruri sunt mentionate despre ana in 1 Samuel 1? (1:10-11)$$, $$[{"id":"a","label":"Se ruga Domnului cu multa amaraciune"},{"id":"b","label":"A facut un juramant Domnului"},{"id":"c","label":"A promis ca, daca primeste un fiu, il va inchina Domnului"}]$$, $$["a","b","c"]$$),
  (22, 'multiple_choice', $$Care dintre următoarele afirmații despre Elcana sunt adevărate? (1:1-5)$$, $$[{"id":"a","label":"Avea doua sotii"},{"id":"b","label":"Ii dadea Anei o parte indoita din jertfa"},{"id":"c","label":"Era din Rama"}]$$, $$["a","b","c"]$$),
  (23, 'multiple_choice', $$Care dintre următoarele afirmații despre fiii lui Eli sunt adevărate? (1:3-2:12)$$, $$[{"id":"a","label":"Se numeau Hofni si Fineas"},{"id":"b","label":"Erau preoti ai Domnului"},{"id":"c","label":"Il cunosteau si se temeau de Domnul"}]$$, $$["a","b"]$$),
  (24, 'multiple_choice', $$Ce lucruri sunt menționate despre Samuel în capitolul 2? (2:18-19)$$, $$[{"id":"a","label":"Slujea inaintea Domnului"},{"id":"b","label":"Purta un efod de in"},{"id":"c","label":"Mama lui facea in fiecare an o mantie mica"}]$$, $$["a","b","c"]$$),
  (25, 'multiple_choice', $$Care dintre următoarele afirmații apar în rugăciunea Anei din 1 Samuel 2? (2:1-8)$$, $$[{"id":"a","label":"\"Inima mea se bucura in Domnul\""},{"id":"b","label":"Domnul este un Dumnezeu care stie totul"},{"id":"c","label":"Domnul inalta pe cel smerit si il ridica din tarana pe cel sarac"}]$$, $$["a","b","c"]$$)
) as v(position, question_type, prompt, options, correct_options);

-- Test: "1 Samuel - Capitolul 1-2" (categoria: 8-9, nivel: medio) - 25 preguntas
with new_test as (
  insert into public.tests (category_id, title, difficulty, is_published)
  values (
    (select id from public.age_categories where name = $$8-9$$),
    $$1 Samuel - Capitolul 1-2$$,
    'medio'::public.exam_difficulty,
    true
  )
  returning id
)
insert into public.questions (test_id, position, question_type, prompt, options, correct_options)
select new_test.id, v.position, v.question_type::public.question_type, v.prompt, v.options::jsonb, v.correct_options::jsonb
from new_test, (values
  (1, 'single_choice', $$Din ce cetate era Elcana?$$, $$[{"id":"a","label":"Betleem"},{"id":"b","label":"Rama"},{"id":"c","label":"Ghibea"}]$$, $$["b"]$$),
  (2, 'single_choice', $$Cum se numeau cele doua sotii ale lui Elcana? (1:2)$$, $$[{"id":"a","label":"Ana si Penina"},{"id":"b","label":"Ana si Mical"},{"id":"c","label":"Penina si Abigail"}]$$, $$["a"]$$),
  (3, 'single_choice', $$De ce era mahnita Ana? (1:6-7)$$, $$[{"id":"a","label":"Pentru ca Elcana o ura"},{"id":"b","label":"Pentru ca Penina o batjocorea din cauza faptului ca nu avea copii"},{"id":"c","label":"Pentru ca nu putea merge la Cortul Intalnirii"}]$$, $$["b"]$$),
  (4, 'single_choice', $$Ce i-a promis Ana Domnului daca ii va da un fiu? (1:11)$$, $$[{"id":"a","label":"Ca il va face preot"},{"id":"b","label":"Ca il va trimite la Ierusalim"},{"id":"c","label":"Ca il va inchina Domnului pentru toate zilele vietii lui"}]$$, $$["c"]$$),
  (5, 'single_choice', $$Cine a crezut ca Ana era beata? (1:12-14)$$, $$[{"id":"a","label":"Elcana"},{"id":"b","label":"Eli"},{"id":"c","label":"Penina si Abigail"}]$$, $$["b"]$$),
  (6, 'single_choice', $$Ce i-a raspuns Ana lui Eli cand acesta a intrebat-o de ce este beata? (1:15-16)$$, $$[{"id":"a","label":"Ca era foarte obosita"},{"id":"b","label":"Ca nu bause vin sau bautura tare, ci isi varsa sufletul inaintea Domnului"},{"id":"c","label":"Ca Penina o facuse sa planga"}]$$, $$["b"]$$),
  (7, 'single_choice', $$Ce nume i-a dat Ana fiului ei?$$, $$[{"id":"a","label":"Samuel"},{"id":"b","label":"Saul"},{"id":"c","label":"I-Cabod"}]$$, $$["a"]$$),
  (8, 'single_choice', $$Cand l-a dus Ana pe Samuel la Casa Domnului? (1:24)$$, $$[{"id":"a","label":"Dupa ce l-a intarcat"},{"id":"b","label":"Imediat dupa nastere"},{"id":"c","label":"Cand a implinit 12 ani"}]$$, $$["a"]$$),
  (9, 'single_choice', $$Ce faceau fiii lui Eli cu jertfele aduse Domnului? (2:12-17)$$, $$[{"id":"a","label":"Le imparteau saracilor"},{"id":"b","label":"Luau pentru ei partea care nu era a lor"},{"id":"c","label":"Le ardeau in intregime"}]$$, $$["b"]$$),
  (10, 'single_choice', $$Ce facea Samuel in slujba Domnului? (2:18)$$, $$[{"id":"a","label":"Purta un efod de in si slujea inaintea Domnului"},{"id":"b","label":"Conducea poporul in lupta"},{"id":"c","label":"Aducea singur toate jertfele"}]$$, $$["a"]$$),
  (11, 'true_false', $$Elcana se suia în fiecare an din cetatea lui ca să se închine și să aducă jertfe Domnului. (1:3)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (12, 'true_false', $$Penina avea copii, iar Ana nu avea copii. (1:2)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (13, 'true_false', $$Elcana i-a spus Anei că pentru el valorează mai mult decât zece fii. (1:8)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (14, 'true_false', $$Ana i-a spus lui Eli că este beată pentru că băuse vin. (1:15)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (15, 'true_false', $$După ce s-a rugat, Ana a plecat și fața ei nu mai era aceeași ca înainte. (1:18)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (16, 'true_false', $$Samuel a fost închinat Domnului pentru toate zilele vieții lui. (1:11,28)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (17, 'true_false', $$Elcana a mers cu Ana când aceasta l-a dus pe Samuel la Casa Domnului. (1:24)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (18, 'true_false', $$Fiii lui Eli erau cunoscuți pentru că se temeau foarte mult de Domnul. (2:12)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (19, 'true_false', $$Samuel slujea înaintea Domnului, fiind încă băiat. (2:18)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (20, 'true_false', $$Ana a mai avut trei fii și două fiice după Samuel. (2:21)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (21, 'multiple_choice', $$Care dintre urmatoarele lucruri sunt mentionate despre ana in 1 Samuel 1? (1:10-11)$$, $$[{"id":"a","label":"Se ruga Domnului cu multa amaraciune"},{"id":"b","label":"A facut un juramant Domnului"},{"id":"c","label":"A promis ca, daca primeste un fiu, il va inchina Domnului"}]$$, $$["a","b","c"]$$),
  (22, 'multiple_choice', $$Care dintre următoarele afirmații despre Elcana sunt adevărate? (1:1-5)$$, $$[{"id":"a","label":"Avea doua sotii"},{"id":"b","label":"Ii dadea Anei o parte indoita din jertfa"},{"id":"c","label":"Era din Rama"}]$$, $$["a","b","c"]$$),
  (23, 'multiple_choice', $$Care dintre următoarele afirmații despre fiii lui Eli sunt adevărate? (1:3-2:12)$$, $$[{"id":"a","label":"Se numeau Hofni si Fineas"},{"id":"b","label":"Erau preoti ai Domnului"},{"id":"c","label":"Il cunosteau si se temeau de Domnul"}]$$, $$["a","b"]$$),
  (24, 'multiple_choice', $$Ce lucruri sunt menționate despre Samuel în capitolul 2? (2:18-19)$$, $$[{"id":"a","label":"Slujea inaintea Domnului"},{"id":"b","label":"Purta un efod de in"},{"id":"c","label":"Mama lui facea in fiecare an o mantie mica"}]$$, $$["a","b","c"]$$),
  (25, 'multiple_choice', $$Care dintre următoarele afirmații apar în rugăciunea Anei din 1 Samuel 2? (2:1-8)$$, $$[{"id":"a","label":"\"Inima mea se bucura in Domnul\""},{"id":"b","label":"Domnul este un Dumnezeu care stie totul"},{"id":"c","label":"Domnul inalta pe cel smerit si il ridica din tarana pe cel sarac"}]$$, $$["a","b","c"]$$)
) as v(position, question_type, prompt, options, correct_options);

-- Test: "1 Samuel - Capitolul 1-2" (categoria: 10-11, nivel: dificil) - 25 preguntas
with new_test as (
  insert into public.tests (category_id, title, difficulty, is_published)
  values (
    (select id from public.age_categories where name = $$10-11$$),
    $$1 Samuel - Capitolul 1-2$$,
    'dificil'::public.exam_difficulty,
    true
  )
  returning id
)
insert into public.questions (test_id, position, question_type, prompt, options, correct_options)
select new_test.id, v.position, v.question_type::public.question_type, v.prompt, v.options::jsonb, v.correct_options::jsonb
from new_test, (values
  (1, 'single_choice', $$Din ce loc era Elcana, conform începutului cărții? (1:1)$$, $$[{"id":"a","label":"Din Ramataim-Tofin, din muntele Lui Efraim"},{"id":"b","label":"Ramataim-Tofim, din tinutul lui Efraim, din muntele lui Tuf"},{"id":"c","label":"Betleem, din tinutul lui Iuda, din muntele lui Efraim"}]$$, $$["a"]$$),
  (2, 'single_choice', $$In ce ordine sunt prezentate sotiile lui Elcana si situatia lor? (1:2)$$, $$[{"id":"a","label":"Penina, care avea copii, si Ana, care nu avea copii"},{"id":"b","label":"Ana, care avea copii, si Penina, care nu avea copii"},{"id":"c","label":"Ana, care nu avea copii, si Penina, care nu avea copii"}]$$, $$["a"]$$),
  (3, 'single_choice', $$Ce facea Elcana in fiecare an cand se suia din cetatea sa? (1:3)$$, $$[{"id":"a","label":"Se inchina si aducea jertfe Domnului ostirilor la Silo"},{"id":"b","label":"Se inchina Domnului si aducea jertfe la Betel"},{"id":"c","label":"Se suia la Ierusalim ca sa aduca jertfe Domnulu"}]$$, $$["a"]$$),
  (4, 'single_choice', $$Ce ii dadea Elcana Anei atunci cand impartea partile din jertfa? (1:4-5)$$, $$[{"id":"a","label":"O parte mai mare decat tuturor fiilor Peninei"},{"id":"b","label":"O parte aleasa, pentru ca o iubea, desi Domnul o facuse stearpa"},{"id":"c","label":"Doua parti, pentru ca Ana era intaia lui sotie"}]$$, $$["b"]$$),
  (5, 'single_choice', $$Ce facea Ana dupa ce a mancat si a baut la Silo? (1:9)$$, $$[{"id":"a","label":"Se intorcea imediat acasa cu Elcana"},{"id":"b","label":"Se ridica si se ducea inaintea Domnului"},{"id":"c","label":"Se ducea sa vorbeasca cu Penina"}]$$, $$["b"]$$),
  (6, 'single_choice', $$Ce NU apare in juramantul Anei din 1 Samuel 1:11?$$, $$[{"id":"a","label":"\"Daca vei binevoi sa te uiti spre intristarea roabei Tale\""},{"id":"b","label":"\"Daca vei da roabei Tale un copil de parte barbateasca\""},{"id":"c","label":"\"Il voi face preot peste Israel\""}]$$, $$["c"]$$),
  (7, 'single_choice', $$Ce a spus Eli dupa ce Ana i-a explicat motivul rugaciunii sale? (1:17)$$, $$[{"id":"a","label":"\"Du-te in pace si Dumnezeul lui Israel sa asculte rugaciunea pe care I-ai facut-o\""},{"id":"b","label":"\"Du-te in pace si Dumnezeu sa asculte rugaciunea pe care I-ai facut-o\""},{"id":"c","label":"\"Domnul sa-ti dea un fiu si sa- faci preot!\""}]$$, $$["b"]$$),
  (8, 'single_choice', $$De ce i-a pus Ana numele Samuel copilului? (1:20)$$, $$[{"id":"a","label":"Pentru ca era primul ei copil"},{"id":"b","label":"Pentru ca il ceruse de la Domnul"},{"id":"c","label":"Pentru ca Eli ii spusese sa-i puna acest nume"}]$$, $$["b"]$$),
  (9, 'single_choice', $$Care dintre urmatoarele descrie corect ceea ce facea Ana pentru Samuel? (2:19)$$, $$[{"id":"a","label":"Ii facea in fiecare an o mantie mica si i-o ducea cand se suia cu barbatul ei sa aduca jertfa anuala"},{"id":"b","label":"Ii facea in fiecare luna haine noi si i le trimitea prin Elcana"},{"id":"c","label":"Ii facea un efod in fiecare an"}]$$, $$["a"]$$),
  (10, 'single_choice', $$Ce motiv este dat pentru care fii lui Eli nu ascultau de tatal lor? (2:12-13)$$, $$[{"id":"a","label":"Pentru ca erau rai si nu cunosteau pe Domnul"},{"id":"b","label":"Pentru ca erau tineri si nu fusesera inca preoti"},{"id":"c","label":"Pentru ca Eli ii trimitea sa slujeasca in alte cetati"}]$$, $$["a"]$$),
  (11, 'true_false', $$Elcana era din Ramataim-Tofin, din muntele Lui Efraim (1:1)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (12, 'true_false', $$Elcana ii dadea Anei o parte indoita deoarece o iubea (1:5)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (13, 'true_false', $$Ana i-a spus lui Eli ca este o femeie cu inima vesela (1:15)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (14, 'true_false', $$Ana duce in fiecare an un miel la Silo (2:19)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (15, 'true_false', $$Dumnezeu a spus ca va lasa casa lui Eli sa continue pentru totdeauna in slujba preotiei (2:30-31)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (16, 'true_false', $$Tanarul Samuel crestea si era placut Domnului si oamenilor (2:26)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (17, 'true_false', $$"Caci voi cinsti pe cine Ma cinsteste, dar cei ce Ma dispretuiesc vor fi iubiti" (2:30)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (18, 'true_false', $$Ana l-a dus pe Samuel la Casa Domnului cand era sugar (1:22-24)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (19, 'true_false', $$Fiii lui Eli se numeau Hofni si Fineas (2:34)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (20, 'true_false', $$Elcana era fiul lui Ieroham, fiul lui Elihu, fiul lui Tohu, fiul lui Tuf$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (21, 'multiple_choice', $$Care dintre urmatoarele elemente apar in juramantul Anei? (1:11)$$, $$[{"id":"a","label":"Sa dea copilul Domnului pentru toate zilele vietii lui"},{"id":"b","label":"Sa nu treaca briciul peste capul lui"},{"id":"c","label":"Sa-l faca nazireu dupa ce va implini 12 ani"}]$$, $$["a","b"]$$),
  (22, 'multiple_choice', $$Care dintre urmatoarele afirmatii despre calatoria la Silo sunt corecte? 1:3-7$$, $$[{"id":"a","label":"Elcana se suia in fiecare an sa se inchine si sa aduca jertfe Domnului"},{"id":"b","label":"Penina o necajea pe Ana atunci cand se suiau la Casa Domnului"},{"id":"c","label":"Ana nu manca si plangea in acele imprejurari"}]$$, $$["a","b","c"]$$),
  (23, 'multiple_choice', $$Care dintre urmatoarele afirmatii despre Samuel sunt corecte?$$, $$[{"id":"a","label":"Numele lui este explicat prin faptul ca Ana il ceruse de la Domnul"},{"id":"b","label":"A fost dus la Casa Domnului dupa ce a fost intarcat"},{"id":"c","label":"A fost crescut in casa lui Eli"}]$$, $$["a","b"]$$),
  (24, 'multiple_choice', $$Care dintre urmatoarele lucruri sunt condamnate in legatura cu fiii lui Eli?$$, $$[{"id":"a","label":"Luau din jertfe inainte ca grasimea sa fie arsa"},{"id":"b","label":"Amenintau oamenii care nu le dadeau carnea"},{"id":"c","label":"Se culcau cu femeile care slujeau la usa Cortului intalnirii"}]$$, $$["a","b","c"]$$),
  (25, 'multiple_choice', $$Care dintre urmatoarele afirmatii apar in cuvantul omului lui Dumnezeu catre Eli? (2:27-35)$$, $$[{"id":"a","label":"Casa lui Eli fusese aleasa pentru slujba preotiei"},{"id":"b","label":"Domnul ii va omori pe cei doi fii ai lui Eli in aceeasi zi"},{"id":"c","label":"Dumnezeu va ridica un preot credincios care va face dupa inima si sufletul Lui"}]$$, $$["a","c"]$$)
) as v(position, question_type, prompt, options, correct_options);

-- Test: "1 Samuel - Capitolul 1-2" (categoria: 18-35, nivel: dificil) - 25 preguntas
with new_test as (
  insert into public.tests (category_id, title, difficulty, is_published)
  values (
    (select id from public.age_categories where name = $$18-35$$),
    $$1 Samuel - Capitolul 1-2$$,
    'dificil'::public.exam_difficulty,
    true
  )
  returning id
)
insert into public.questions (test_id, position, question_type, prompt, options, correct_options)
select new_test.id, v.position, v.question_type::public.question_type, v.prompt, v.options::jsonb, v.correct_options::jsonb
from new_test, (values
  (1, 'single_choice', $$Din ce loc era Elcana, conform începutului cărții? (1:1)$$, $$[{"id":"a","label":"Din Ramataim-Tofin, din muntele Lui Efraim"},{"id":"b","label":"Ramataim-Tofim, din tinutul lui Efraim, din muntele lui Tuf"},{"id":"c","label":"Betleem, din tinutul lui Iuda, din muntele lui Efraim"}]$$, $$["a"]$$),
  (2, 'single_choice', $$In ce ordine sunt prezentate sotiile lui Elcana si situatia lor? (1:2)$$, $$[{"id":"a","label":"Penina, care avea copii, si Ana, care nu avea copii"},{"id":"b","label":"Ana, care avea copii, si Penina, care nu avea copii"},{"id":"c","label":"Ana, care nu avea copii, si Penina, care nu avea copii"}]$$, $$["a"]$$),
  (3, 'single_choice', $$Ce facea Elcana in fiecare an cand se suia din cetatea sa? (1:3)$$, $$[{"id":"a","label":"Se inchina si aducea jertfe Domnului ostirilor la Silo"},{"id":"b","label":"Se inchina Domnului si aducea jertfe la Betel"},{"id":"c","label":"Se suia la Ierusalim ca sa aduca jertfe Domnulu"}]$$, $$["a"]$$),
  (4, 'single_choice', $$Ce ii dadea Elcana Anei atunci cand impartea partile din jertfa? (1:4-5)$$, $$[{"id":"a","label":"O parte mai mare decat tuturor fiilor Peninei"},{"id":"b","label":"O parte aleasa, pentru ca o iubea, desi Domnul o facuse stearpa"},{"id":"c","label":"Doua parti, pentru ca Ana era intaia lui sotie"}]$$, $$["b"]$$),
  (5, 'single_choice', $$Ce facea Ana dupa ce a mancat si a baut la Silo? (1:9)$$, $$[{"id":"a","label":"Se intorcea imediat acasa cu Elcana"},{"id":"b","label":"Se ridica si se ducea inaintea Domnului"},{"id":"c","label":"Se ducea sa vorbeasca cu Penina"}]$$, $$["b"]$$),
  (6, 'single_choice', $$Ce NU apare in juramantul Anei din 1 Samuel 1:11?$$, $$[{"id":"a","label":"\"Daca vei binevoi sa te uiti spre intristarea roabei Tale\""},{"id":"b","label":"\"Daca vei da roabei Tale un copil de parte barbateasca\""},{"id":"c","label":"\"Il voi face preot peste Israel\""}]$$, $$["c"]$$),
  (7, 'single_choice', $$Ce a spus Eli dupa ce Ana i-a explicat motivul rugaciunii sale? (1:17)$$, $$[{"id":"a","label":"\"Du-te in pace si Dumnezeul lui Israel sa asculte rugaciunea pe care I-ai facut-o\""},{"id":"b","label":"\"Du-te in pace si Dumnezeu sa asculte rugaciunea pe care I-ai facut-o\""},{"id":"c","label":"\"Domnul sa-ti dea un fiu si sa- faci preot!\""}]$$, $$["b"]$$),
  (8, 'single_choice', $$De ce i-a pus Ana numele Samuel copilului? (1:20)$$, $$[{"id":"a","label":"Pentru ca era primul ei copil"},{"id":"b","label":"Pentru ca il ceruse de la Domnul"},{"id":"c","label":"Pentru ca Eli ii spusese sa-i puna acest nume"}]$$, $$["b"]$$),
  (9, 'single_choice', $$Care dintre urmatoarele descrie corect ceea ce facea Ana pentru Samuel? (2:19)$$, $$[{"id":"a","label":"Ii facea in fiecare an o mantie mica si i-o ducea cand se suia cu barbatul ei sa aduca jertfa anuala"},{"id":"b","label":"Ii facea in fiecare luna haine noi si i le trimitea prin Elcana"},{"id":"c","label":"Ii facea un efod in fiecare an"}]$$, $$["a"]$$),
  (10, 'single_choice', $$Ce motiv este dat pentru care fii lui Eli nu ascultau de tatal lor? (2:12-13)$$, $$[{"id":"a","label":"Pentru ca erau rai si nu cunosteau pe Domnul"},{"id":"b","label":"Pentru ca erau tineri si nu fusesera inca preoti"},{"id":"c","label":"Pentru ca Eli ii trimitea sa slujeasca in alte cetati"}]$$, $$["a"]$$),
  (11, 'true_false', $$Elcana era din Ramataim-Tofin, din muntele Lui Efraim (1:1)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (12, 'true_false', $$Elcana ii dadea Anei o parte indoita deoarece o iubea (1:5)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (13, 'true_false', $$Ana i-a spus lui Eli ca este o femeie cu inima vesela (1:15)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (14, 'true_false', $$Ana duce in fiecare an un miel la Silo (2:19)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (15, 'true_false', $$Dumnezeu a spus ca va lasa casa lui Eli sa continue pentru totdeauna in slujba preotiei (2:30-31)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (16, 'true_false', $$Tanarul Samuel crestea si era placut Domnului si oamenilor (2:26)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (17, 'true_false', $$"Caci voi cinsti pe cine Ma cinsteste, dar cei ce Ma dispretuiesc vor fi iubiti" (2:30)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (18, 'true_false', $$Ana l-a dus pe Samuel la Casa Domnului cand era sugar (1:22-24)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (19, 'true_false', $$Fiii lui Eli se numeau Hofni si Fineas (2:34)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (20, 'true_false', $$Elcana era fiul lui Ieroham, fiul lui Elihu, fiul lui Tohu, fiul lui Tuf$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (21, 'multiple_choice', $$Care dintre urmatoarele elemente apar in juramantul Anei? (1:11)$$, $$[{"id":"a","label":"Sa dea copilul Domnului pentru toate zilele vietii lui"},{"id":"b","label":"Sa nu treaca briciul peste capul lui"},{"id":"c","label":"Sa-l faca nazireu dupa ce va implini 12 ani"}]$$, $$["a","b"]$$),
  (22, 'multiple_choice', $$Care dintre urmatoarele afirmatii despre calatoria la Silo sunt corecte? 1:3-7$$, $$[{"id":"a","label":"Elcana se suia in fiecare an sa se inchine si sa aduca jertfe Domnului"},{"id":"b","label":"Penina o necajea pe Ana atunci cand se suiau la Casa Domnului"},{"id":"c","label":"Ana nu manca si plangea in acele imprejurari"}]$$, $$["a","b","c"]$$),
  (23, 'multiple_choice', $$Care dintre urmatoarele afirmatii despre Samuel sunt corecte?$$, $$[{"id":"a","label":"Numele lui este explicat prin faptul ca Ana il ceruse de la Domnul"},{"id":"b","label":"A fost dus la Casa Domnului dupa ce a fost intarcat"},{"id":"c","label":"A fost crescut in casa lui Eli"}]$$, $$["a","b"]$$),
  (24, 'multiple_choice', $$Care dintre urmatoarele lucruri sunt condamnate in legatura cu fiii lui Eli?$$, $$[{"id":"a","label":"Luau din jertfe inainte ca grasimea sa fie arsa"},{"id":"b","label":"Amenintau oamenii care nu le dadeau carnea"},{"id":"c","label":"Se culcau cu femeile care slujeau la usa Cortului intalnirii"}]$$, $$["a","b","c"]$$),
  (25, 'multiple_choice', $$Care dintre urmatoarele afirmatii apar in cuvantul omului lui Dumnezeu catre Eli? (2:27-35)$$, $$[{"id":"a","label":"Casa lui Eli fusese aleasa pentru slujba preotiei"},{"id":"b","label":"Domnul ii va omori pe cei doi fii ai lui Eli in aceeasi zi"},{"id":"c","label":"Dumnezeu va ridica un preot credincios care va face dupa inima si sufletul Lui"}]$$, $$["a","c"]$$)
) as v(position, question_type, prompt, options, correct_options);

-- Test: "1 Samuel - Capitolul 1-2" (categoria: +35, nivel: dificil) - 25 preguntas
with new_test as (
  insert into public.tests (category_id, title, difficulty, is_published)
  values (
    (select id from public.age_categories where name = $$+35$$),
    $$1 Samuel - Capitolul 1-2$$,
    'dificil'::public.exam_difficulty,
    true
  )
  returning id
)
insert into public.questions (test_id, position, question_type, prompt, options, correct_options)
select new_test.id, v.position, v.question_type::public.question_type, v.prompt, v.options::jsonb, v.correct_options::jsonb
from new_test, (values
  (1, 'single_choice', $$Din ce loc era Elcana, conform începutului cărții? (1:1)$$, $$[{"id":"a","label":"Din Ramataim-Tofin, din muntele Lui Efraim"},{"id":"b","label":"Ramataim-Tofim, din tinutul lui Efraim, din muntele lui Tuf"},{"id":"c","label":"Betleem, din tinutul lui Iuda, din muntele lui Efraim"}]$$, $$["a"]$$),
  (2, 'single_choice', $$In ce ordine sunt prezentate sotiile lui Elcana si situatia lor? (1:2)$$, $$[{"id":"a","label":"Penina, care avea copii, si Ana, care nu avea copii"},{"id":"b","label":"Ana, care avea copii, si Penina, care nu avea copii"},{"id":"c","label":"Ana, care nu avea copii, si Penina, care nu avea copii"}]$$, $$["a"]$$),
  (3, 'single_choice', $$Ce facea Elcana in fiecare an cand se suia din cetatea sa? (1:3)$$, $$[{"id":"a","label":"Se inchina si aducea jertfe Domnului ostirilor la Silo"},{"id":"b","label":"Se inchina Domnului si aducea jertfe la Betel"},{"id":"c","label":"Se suia la Ierusalim ca sa aduca jertfe Domnulu"}]$$, $$["a"]$$),
  (4, 'single_choice', $$Ce ii dadea Elcana Anei atunci cand impartea partile din jertfa? (1:4-5)$$, $$[{"id":"a","label":"O parte mai mare decat tuturor fiilor Peninei"},{"id":"b","label":"O parte aleasa, pentru ca o iubea, desi Domnul o facuse stearpa"},{"id":"c","label":"Doua parti, pentru ca Ana era intaia lui sotie"}]$$, $$["b"]$$),
  (5, 'single_choice', $$Ce facea Ana dupa ce a mancat si a baut la Silo? (1:9)$$, $$[{"id":"a","label":"Se intorcea imediat acasa cu Elcana"},{"id":"b","label":"Se ridica si se ducea inaintea Domnului"},{"id":"c","label":"Se ducea sa vorbeasca cu Penina"}]$$, $$["b"]$$),
  (6, 'single_choice', $$Ce NU apare in juramantul Anei din 1 Samuel 1:11?$$, $$[{"id":"a","label":"\"Daca vei binevoi sa te uiti spre intristarea roabei Tale\""},{"id":"b","label":"\"Daca vei da roabei Tale un copil de parte barbateasca\""},{"id":"c","label":"\"Il voi face preot peste Israel\""}]$$, $$["c"]$$),
  (7, 'single_choice', $$Ce a spus Eli dupa ce Ana i-a explicat motivul rugaciunii sale? (1:17)$$, $$[{"id":"a","label":"\"Du-te in pace si Dumnezeul lui Israel sa asculte rugaciunea pe care I-ai facut-o\""},{"id":"b","label":"\"Du-te in pace si Dumnezeu sa asculte rugaciunea pe care I-ai facut-o\""},{"id":"c","label":"\"Domnul sa-ti dea un fiu si sa- faci preot!\""}]$$, $$["b"]$$),
  (8, 'single_choice', $$De ce i-a pus Ana numele Samuel copilului? (1:20)$$, $$[{"id":"a","label":"Pentru ca era primul ei copil"},{"id":"b","label":"Pentru ca il ceruse de la Domnul"},{"id":"c","label":"Pentru ca Eli ii spusese sa-i puna acest nume"}]$$, $$["b"]$$),
  (9, 'single_choice', $$Care dintre urmatoarele descrie corect ceea ce facea Ana pentru Samuel? (2:19)$$, $$[{"id":"a","label":"Ii facea in fiecare an o mantie mica si i-o ducea cand se suia cu barbatul ei sa aduca jertfa anuala"},{"id":"b","label":"Ii facea in fiecare luna haine noi si i le trimitea prin Elcana"},{"id":"c","label":"Ii facea un efod in fiecare an"}]$$, $$["a"]$$),
  (10, 'single_choice', $$Ce motiv este dat pentru care fii lui Eli nu ascultau de tatal lor? (2:12-13)$$, $$[{"id":"a","label":"Pentru ca erau rai si nu cunosteau pe Domnul"},{"id":"b","label":"Pentru ca erau tineri si nu fusesera inca preoti"},{"id":"c","label":"Pentru ca Eli ii trimitea sa slujeasca in alte cetati"}]$$, $$["a"]$$),
  (11, 'true_false', $$Elcana era din Ramataim-Tofin, din muntele Lui Efraim (1:1)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (12, 'true_false', $$Elcana ii dadea Anei o parte indoita deoarece o iubea (1:5)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (13, 'true_false', $$Ana i-a spus lui Eli ca este o femeie cu inima vesela (1:15)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (14, 'true_false', $$Ana duce in fiecare an un miel la Silo (2:19)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (15, 'true_false', $$Dumnezeu a spus ca va lasa casa lui Eli sa continue pentru totdeauna in slujba preotiei (2:30-31)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (16, 'true_false', $$Tanarul Samuel crestea si era placut Domnului si oamenilor (2:26)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (17, 'true_false', $$"Caci voi cinsti pe cine Ma cinsteste, dar cei ce Ma dispretuiesc vor fi iubiti" (2:30)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (18, 'true_false', $$Ana l-a dus pe Samuel la Casa Domnului cand era sugar (1:22-24)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["b"]$$),
  (19, 'true_false', $$Fiii lui Eli se numeau Hofni si Fineas (2:34)$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (20, 'true_false', $$Elcana era fiul lui Ieroham, fiul lui Elihu, fiul lui Tohu, fiul lui Tuf$$, $$[{"id":"a","label":"Adevarat"},{"id":"b","label":"Fals"}]$$, $$["a"]$$),
  (21, 'multiple_choice', $$Care dintre urmatoarele elemente apar in juramantul Anei? (1:11)$$, $$[{"id":"a","label":"Sa dea copilul Domnului pentru toate zilele vietii lui"},{"id":"b","label":"Sa nu treaca briciul peste capul lui"},{"id":"c","label":"Sa-l faca nazireu dupa ce va implini 12 ani"}]$$, $$["a","b"]$$),
  (22, 'multiple_choice', $$Care dintre urmatoarele afirmatii despre calatoria la Silo sunt corecte? 1:3-7$$, $$[{"id":"a","label":"Elcana se suia in fiecare an sa se inchine si sa aduca jertfe Domnului"},{"id":"b","label":"Penina o necajea pe Ana atunci cand se suiau la Casa Domnului"},{"id":"c","label":"Ana nu manca si plangea in acele imprejurari"}]$$, $$["a","b","c"]$$),
  (23, 'multiple_choice', $$Care dintre urmatoarele afirmatii despre Samuel sunt corecte?$$, $$[{"id":"a","label":"Numele lui este explicat prin faptul ca Ana il ceruse de la Domnul"},{"id":"b","label":"A fost dus la Casa Domnului dupa ce a fost intarcat"},{"id":"c","label":"A fost crescut in casa lui Eli"}]$$, $$["a","b"]$$),
  (24, 'multiple_choice', $$Care dintre urmatoarele lucruri sunt condamnate in legatura cu fiii lui Eli?$$, $$[{"id":"a","label":"Luau din jertfe inainte ca grasimea sa fie arsa"},{"id":"b","label":"Amenintau oamenii care nu le dadeau carnea"},{"id":"c","label":"Se culcau cu femeile care slujeau la usa Cortului intalnirii"}]$$, $$["a","b","c"]$$),
  (25, 'multiple_choice', $$Care dintre urmatoarele afirmatii apar in cuvantul omului lui Dumnezeu catre Eli? (2:27-35)$$, $$[{"id":"a","label":"Casa lui Eli fusese aleasa pentru slujba preotiei"},{"id":"b","label":"Domnul ii va omori pe cei doi fii ai lui Eli in aceeasi zi"},{"id":"c","label":"Dumnezeu va ridica un preot credincios care va face dupa inima si sufletul Lui"}]$$, $$["a","c"]$$)
) as v(position, question_type, prompt, options, correct_options);

commit;
