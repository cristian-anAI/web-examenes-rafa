-- Self-registration: participants create their own account (name, surname, birth date,
-- username, password and category) instead of an admin creating profiles manually.

alter table public.profiles
  add column if not exists first_name text,
  add column if not exists last_name text,
  add column if not exists birth_date date;

comment on column public.profiles.birth_date is 'Collected at signup to warn (non-blocking) when it does not match the chosen category age range.';

-- Replace the admin-only insert policy: a signed-up user may now create their own
-- profile row right after auth.signUp(), but can never set is_admin = true on it.
drop policy if exists "profiles_admin_write" on public.profiles;
create policy "profiles_insert_self_or_admin" on public.profiles
  for insert to authenticated
  with check (
    public.is_admin()
    or (id = auth.uid() and is_admin = false)
  );

-- Same guard on updates: participants can edit their own row but never grant themselves admin.
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update to authenticated
  using (id = auth.uid() or public.is_admin())
  with check (
    public.is_admin()
    or (id = auth.uid() and is_admin = false)
  );

-- age_categories must be readable before login (anon) so the signup form can list them.
drop policy if exists "age_categories_select" on public.age_categories;
create policy "age_categories_select" on public.age_categories
  for select to anon, authenticated using (true);
