-- Настройка прав доступа для регистрации новых пользователей
-- Выполните этот скрипт в SQL Editor вашей панели Supabase

-- 1. Разрешить вставку своего профиля при регистрации
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;
CREATE POLICY "profiles_insert_own"
ON public.profiles
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- 2. Разрешить пользователям читать свой собственный профиль
DROP POLICY IF EXISTS "profiles_read_own" ON public.profiles;
CREATE POLICY "profiles_read_own"
ON public.profiles
FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- 3. Разрешить пользователям обновлять свой собственный профиль (имя и т.д.)
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
CREATE POLICY "profiles_update_own"
ON public.profiles
FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Примечание: Убедитесь, что RLS включен для таблицы profiles:
-- ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
