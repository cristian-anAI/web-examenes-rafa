-- These views are owned by the migration role and therefore bypass the row-level
-- security policies on test_attempts / attempt_answers (standard Postgres behaviour:
-- table owners bypass RLS). This is intentional: it lets every participant see the
-- aggregated rankings while the raw attempt rows stay locked down to their own user.

create view public.test_rankings as
select
  a.test_id,
  a.user_id,
  p.display_name,
  a.score,
  a.elapsed_seconds,
  a.submitted_at,
  rank() over (
    partition by a.test_id
    order by a.score desc, a.elapsed_seconds asc, a.submitted_at asc
  ) as rank
from public.test_attempts a
join public.profiles p on p.id = a.user_id;

create view public.category_rankings as
select
  t.category_id,
  a.user_id,
  p.display_name,
  count(*) as attempts_count,
  sum(a.score) as total_score,
  avg(a.score) as average_score,
  rank() over (
    partition by t.category_id
    order by sum(a.score) desc, avg(a.score) desc
  ) as rank
from public.test_attempts a
join public.tests t on t.id = a.test_id
join public.profiles p on p.id = a.user_id
group by t.category_id, a.user_id, p.display_name;

create view public.general_rankings as
select
  a.user_id,
  p.display_name,
  p.category_id,
  c.name as category_name,
  count(*) as attempts_count,
  sum(a.score) as total_score,
  avg(a.score) as average_score,
  rank() over (
    order by sum(a.score) desc, avg(a.score) desc
  ) as rank
from public.test_attempts a
join public.profiles p on p.id = a.user_id
join public.age_categories c on c.id = p.category_id
group by a.user_id, p.display_name, p.category_id, c.name;

grant select on public.test_rankings to authenticated;
grant select on public.category_rankings to authenticated;
grant select on public.general_rankings to authenticated;
