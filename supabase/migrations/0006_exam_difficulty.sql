create type public.exam_difficulty as enum ('facil', 'medio', 'dificil');

alter table public.profiles
  add column difficulty public.exam_difficulty not null default 'facil';

alter table public.tests
  add column difficulty public.exam_difficulty not null default 'facil';

create or replace function public.current_exam_difficulty()
returns public.exam_difficulty
language sql
security definer
set search_path = public
stable
as $$
  select difficulty from public.profiles where id = auth.uid();
$$;

drop policy if exists "tests_select_own_category" on public.tests;
create policy "tests_select_own_category" on public.tests
  for select to authenticated
  using (
    public.is_admin()
    or (
      is_published
      and category_id = public.current_category_id()
      and difficulty = public.current_exam_difficulty()
    )
  );

create or replace function public.get_test_questions(p_test_id uuid)
returns table (
  id uuid,
  test_id uuid,
  "position" integer,
  question_type public.question_type,
  prompt text,
  options jsonb
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (
    select 1 from public.tests t
    where t.id = p_test_id
      and t.is_published
      and (
        public.is_admin()
        or (
          t.category_id = public.current_category_id()
          and t.difficulty = public.current_exam_difficulty()
        )
      )
      and (t.starts_at is null or t.starts_at <= now())
      and (t.ends_at is null or t.ends_at >= now())
  ) then
    raise exception 'Test not available';
  end if;

  return query
    select q.id, q.test_id, q.position, q.question_type, q.prompt, q.options
    from public.questions q
    where q.test_id = p_test_id
    order by q.position;
end;
$$;

create or replace function public.submit_attempt(
  p_test_id uuid,
  p_elapsed_seconds integer,
  p_answers jsonb
)
returns table (attempt_id uuid, score numeric)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid := auth.uid();
  v_attempt_id uuid := gen_random_uuid();
  v_total integer := 0;
  v_correct integer := 0;
  v_score numeric(5,2);
  v_answer jsonb;
  v_question public.questions;
  v_selected jsonb;
  v_is_correct boolean;
begin
  if v_user_id is null then
    raise exception 'Not authenticated';
  end if;

  if not exists (
    select 1 from public.tests t
    where t.id = p_test_id
      and t.is_published
      and t.category_id = public.current_category_id()
      and t.difficulty = public.current_exam_difficulty()
      and (t.starts_at is null or t.starts_at <= now())
      and (t.ends_at is null or t.ends_at >= now())
  ) then
    raise exception 'Test not available';
  end if;

  if exists (select 1 from public.test_attempts where test_id = p_test_id and user_id = v_user_id) then
    raise exception 'Attempt already submitted';
  end if;

  for v_answer in select * from jsonb_array_elements(p_answers)
  loop
    select q.* into v_question
    from public.questions q
    where q.id = (v_answer->>'question_id')::uuid and q.test_id = p_test_id;

    if not found then
      raise exception 'Unknown question %', v_answer->>'question_id';
    end if;

    v_selected := coalesce(v_answer->'selected_options', '[]'::jsonb);

    v_is_correct := (
      select coalesce(array_agg(value order by value), array[]::text[])
      from jsonb_array_elements_text(v_selected)
    ) = (
      select coalesce(array_agg(value order by value), array[]::text[])
      from jsonb_array_elements_text(v_question.correct_options)
    );

    v_total := v_total + 1;
    if v_is_correct then
      v_correct := v_correct + 1;
    end if;
  end loop;

  if v_total = 0 then
    raise exception 'No answers submitted';
  end if;

  v_score := round((v_correct::numeric / v_total::numeric) * 100, 2);

  insert into public.test_attempts (id, test_id, user_id, score, elapsed_seconds)
  values (v_attempt_id, p_test_id, v_user_id, v_score, p_elapsed_seconds);

  for v_answer in select * from jsonb_array_elements(p_answers)
  loop
    select q.* into v_question
    from public.questions q
    where q.id = (v_answer->>'question_id')::uuid and q.test_id = p_test_id;

    v_selected := coalesce(v_answer->'selected_options', '[]'::jsonb);

    v_is_correct := (
      select coalesce(array_agg(value order by value), array[]::text[])
      from jsonb_array_elements_text(v_selected)
    ) = (
      select coalesce(array_agg(value order by value), array[]::text[])
      from jsonb_array_elements_text(v_question.correct_options)
    );

    insert into public.attempt_answers (attempt_id, question_id, selected_options, is_correct)
    values (v_attempt_id, (v_answer->>'question_id')::uuid, v_selected, v_is_correct);
  end loop;

  return query select v_attempt_id, v_score;
end;
$$;

drop view public.category_rankings;
create view public.category_rankings as
select
  t.category_id,
  t.difficulty,
  a.user_id,
  p.display_name,
  count(*) as attempts_count,
  sum(a.score) as total_score,
  avg(a.score) as average_score,
  rank() over (
    partition by t.category_id, t.difficulty
    order by sum(a.score) desc, avg(a.score) desc
  ) as rank
from public.test_attempts a
join public.tests t on t.id = a.test_id
join public.profiles p on p.id = a.user_id
group by t.category_id, t.difficulty, a.user_id, p.display_name;

drop view public.general_rankings;
create view public.general_rankings as
select
  a.user_id,
  p.display_name,
  p.category_id,
  c.name as category_name,
  p.difficulty,
  count(*) as attempts_count,
  sum(a.score) as total_score,
  avg(a.score) as average_score,
  rank() over (
    partition by p.difficulty
    order by sum(a.score) desc, avg(a.score) desc
  ) as rank
from public.test_attempts a
join public.profiles p on p.id = a.user_id
join public.age_categories c on c.id = p.category_id
group by a.user_id, p.display_name, p.category_id, c.name, p.difficulty;

grant select on public.category_rankings to authenticated;
grant select on public.general_rankings to authenticated;
