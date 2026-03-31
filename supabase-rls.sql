-- RLS/policies for "2 вариант" (только авторизованный admin)
--
-- Assumptions:
-- 1) profiles.id = auth.users.id
-- 2) profiles.role in ('student','teacher','parent','admin')
--
-- Enable RLS
alter table public.profiles enable row level security;
alter table public.grades enable row level security;
alter table public.events enable row level security;
alter table public.schedule enable row level security;
alter table public.audit_logs enable row level security;
alter table public.notifications enable row level security;
alter table public.leaderboard_points enable row level security;
alter table public.achievements enable row level security;

-- Helper: is admin
create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = auth.uid() and p.role = 'admin'
  );
$$;

-- PROFILES
drop policy if exists "profiles_admin_all" on public.profiles;
create policy "profiles_admin_all"
on public.profiles
as permissive
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- Allow each authenticated user to create/read/update own profile
drop policy if exists "profiles_user_read_own" on public.profiles;
create policy "profiles_user_read_own"
on public.profiles
as permissive
for select
to authenticated
using (id = auth.uid());

drop policy if exists "profiles_user_insert_own" on public.profiles;
create policy "profiles_user_insert_own"
on public.profiles
as permissive
for insert
to authenticated
with check (id = auth.uid());

drop policy if exists "profiles_user_update_own" on public.profiles;
create policy "profiles_user_update_own"
on public.profiles
as permissive
for update
to authenticated
using (id = auth.uid())
with check (id = auth.uid());

-- GRADES (admin all; students can read own)
drop policy if exists "grades_admin_all" on public.grades;
create policy "grades_admin_all"
on public.grades
as permissive
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "grades_student_read_own" on public.grades;
create policy "grades_student_read_own"
on public.grades
as permissive
for select
to authenticated
using (student_id = auth.uid());

-- EVENTS (admin write; all authenticated read)
drop policy if exists "events_auth_read" on public.events;
create policy "events_auth_read"
on public.events
as permissive
for select
to authenticated
using (true);

drop policy if exists "events_admin_write" on public.events;
create policy "events_admin_write"
on public.events
as permissive
for insert, update, delete
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- SCHEDULE (admin all; all authenticated read)
drop policy if exists "schedule_auth_read" on public.schedule;
create policy "schedule_auth_read"
on public.schedule
as permissive
for select
to authenticated
using (true);

drop policy if exists "schedule_admin_write" on public.schedule;
create policy "schedule_admin_write"
on public.schedule
as permissive
for insert, update, delete
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- AUDIT LOGS (admin read/write)
drop policy if exists "audit_admin_all" on public.audit_logs;
create policy "audit_admin_all"
on public.audit_logs
as permissive
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- NOTIFICATIONS
drop policy if exists "notifications_admin_all" on public.notifications;
create policy "notifications_admin_all"
on public.notifications
as permissive
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "notifications_user_read_own" on public.notifications;
create policy "notifications_user_read_own"
on public.notifications
as permissive
for select
to authenticated
using (user_id = auth.uid());

-- LEADERBOARD
drop policy if exists "leaderboard_auth_read" on public.leaderboard_points;
create policy "leaderboard_auth_read"
on public.leaderboard_points
as permissive
for select
to authenticated
using (true);

drop policy if exists "leaderboard_admin_write" on public.leaderboard_points;
create policy "leaderboard_admin_write"
on public.leaderboard_points
as permissive
for insert, update, delete
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- ACHIEVEMENTS
drop policy if exists "achievements_auth_read" on public.achievements;
create policy "achievements_auth_read"
on public.achievements
as permissive
for select
to authenticated
using (public.is_admin() or student_id = auth.uid());

drop policy if exists "achievements_admin_write" on public.achievements;
create policy "achievements_admin_write"
on public.achievements
as permissive
for insert, update, delete
to authenticated
using (public.is_admin())
with check (public.is_admin());

