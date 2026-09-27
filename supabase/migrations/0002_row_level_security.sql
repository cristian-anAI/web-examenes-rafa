-- Enable RLS everywhere; access is granted explicitly through the policies below.
alter table public.age_categories enable row level security;
alter table public.profiles enable row level security;
alter table public.tests enable row level security;
alter table public.questions enable row level security;
alter table public.test_attempts enable row level security;
alter table public.attempt_answers enable row level security;

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce((select is_admin from public.profiles where id = auth.uid()), false);
$$;

create or replace function public.current_category_id()
returns uuid
language sql
security definer
set search_path = public
stable
as $$
  select category_id from public.profiles where id = auth.uid();
$$;

-- age_categories: readable by any signed-in participant, writable only by admins.
create policy "age_categories_select" on public.age_categories
  for select to authenticated using (true);
create policy "age_categories_write" on public.age_categories
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- profiles: a participant sees and edits only their own row; admins see everyone.
create policy "profiles_select_own_or_admin" on public.profiles
  for select to authenticated using (id = auth.uid() or public.is_admin());
create policy "profiles_update_own" on public.profiles
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());
create policy "profiles_admin_write" on public.profiles
  for insert to authenticated with check (public.is_admin());

-- tests: participants only see published tests for their own category; admins see all.
create policy "tests_select_own_category" on public.tests
  for select to authenticated
  using (public.is_admin() or (is_published and category_id = public.current_category_id()));
create policy "tests_admin_write" on public.tests
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- questions: never exposed with correct_options to regular participants (see questions_public view).
-- Only admins may query this table directly from the client.
create policy "questions_admin_only" on public.questions
  for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- test_attempts: participants only see their own attempts; inserts happen exclusively
-- through the security-definer submit_attempt() function, never directly from the client.
create policy "test_attempts_select_own_or_admin" on public.test_attempts
  for select to authenticated using (user_id = auth.uid() or public.is_admin());

-- attempt_answers: same visibility rule, also insert-only through submit_attempt().
create policy "attempt_answers_select_own_or_admin" on public.attempt_answers
  for select to authenticated using (
    public.is_admin() or exists (
      select 1 from public.test_attempts a
      where a.id = attempt_answers.attempt_id and a.user_id = auth.uid()
    )
  );

revoke insert, update, delete on public.test_attempts from authenticated;
revoke insert, update, delete on public.attempt_answers from authenticated;
