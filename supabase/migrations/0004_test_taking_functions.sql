-- Read path: questions are never sent to the browser with their correct_options.
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
      and (public.is_admin() or t.category_id = public.current_category_id())
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

grant execute on function public.get_test_questions(uuid) to authenticated;

-- Write path: the only way to create a test_attempt / attempt_answers rows.
-- Grading happens here, server-side, so correct_options never has to leave Postgres.
create or replace function public.submit_attempt(
  p_test_id uuid,
  p_elapsed_seconds integer,
  p_answers jsonb -- array of {"question_id": uuid, "selected_options": [text, ...]}
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
      and (t.starts_at is null or t.starts_at <= now())
      and (t.ends_at is null or t.ends_at >= now())
  ) then
    raise exception 'Test not available';
  end if;

  if exists (select 1 from public.test_attempts where test_id = p_test_id and user_id = v_user_id) then
    raise exception 'Attempt already submitted';
  end if;

  -- Pass 1: grade every answer without writing anything yet.
  for v_answer in select * from jsonb_array_elements(p_answers)
  loop
    select q.* into v_question
    from public.questions q
    where q.id = (v_answer->>'question_id')::uuid and q.test_id = p_test_id;

    if not found then
      raise exception 'Unknown question %', v_answer->>'question_id';
    end if;

    v_selected := coalesce(v_answer->'selected_options', '[]'::jsonb);

    -- order-independent equality between the selected and correct option sets
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

  -- Pass 2: now that the attempt row exists, persist each graded answer.
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

grant execute on function public.submit_attempt(uuid, integer, jsonb) to authenticated;
