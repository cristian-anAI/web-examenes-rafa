create table public.age_categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  min_age smallint not null,
  max_age smallint not null,
  created_at timestamptz not null default now(),
  constraint valid_age_range check (min_age >= 0 and max_age >= min_age)
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  display_name text not null,
  category_id uuid not null references public.age_categories(id),
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

comment on column public.profiles.username is 'Login handle typed by the participant; auth.users.email stores a synthetic <username>@participants.local address.';

create type public.question_type as enum ('true_false', 'single_choice', 'multiple_choice');

create table public.tests (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.age_categories(id),
  title text not null,
  is_published boolean not null default false,
  starts_at timestamptz,
  ends_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.questions (
  id uuid primary key default gen_random_uuid(),
  test_id uuid not null references public.tests(id) on delete cascade,
  position integer not null,
  question_type public.question_type not null,
  prompt text not null,
  options jsonb not null default '[]'::jsonb,
  correct_options jsonb not null default '[]'::jsonb,
  unique (test_id, position)
);

create table public.test_attempts (
  id uuid primary key default gen_random_uuid(),
  test_id uuid not null references public.tests(id),
  user_id uuid not null references auth.users(id),
  score numeric(5,2) not null,
  elapsed_seconds integer not null,
  submitted_at timestamptz not null default now(),
  -- one attempt per test per participant; revisit if the teacher wants retries
  unique (test_id, user_id)
);

create table public.attempt_answers (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references public.test_attempts(id) on delete cascade,
  question_id uuid not null references public.questions(id),
  selected_options jsonb not null default '[]'::jsonb,
  is_correct boolean not null,
  unique (attempt_id, question_id)
);

comment on table public.questions is 'correct_options must only be returned to trusted server-side correction logic.';
