-- Server-side safety net: profiles.difficulty must always match the
-- professor's fixed category -> difficulty mapping (2-3/4-5 = facil,
-- 6-7/8-9 = medio, 10-11/18-35/+35 = dificil), regardless of whatever
-- value a client sends. The frontend already computes this correctly at
-- signup, but a trigger keeps it correct even against direct API calls or
-- future bugs, consistent with how submit_attempt() never trusts the
-- client for scoring.

create or replace function public.difficulty_for_min_age(p_min_age smallint)
returns public.exam_difficulty
language sql
immutable
as $$
  select case
    when p_min_age <= 5 then 'facil'::public.exam_difficulty
    when p_min_age <= 9 then 'medio'::public.exam_difficulty
    else 'dificil'::public.exam_difficulty
  end;
$$;

create or replace function public.set_profile_difficulty()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  select public.difficulty_for_min_age(min_age) into new.difficulty
  from public.age_categories
  where id = new.category_id;
  return new;
end;
$$;

drop trigger if exists profiles_set_difficulty on public.profiles;
create trigger profiles_set_difficulty
  before insert or update of category_id, difficulty on public.profiles
  for each row execute function public.set_profile_difficulty();

-- Fix any existing rows that predate this trigger.
update public.profiles p
set difficulty = public.difficulty_for_min_age(ac.min_age)
from public.age_categories ac
where ac.id = p.category_id
  and p.difficulty <> public.difficulty_for_min_age(ac.min_age);
