ALTER TABLE public.organizational_roles
ADD COLUMN role_category TEXT NOT NULL DEFAULT 'staff';

ALTER TABLE public.organizational_roles
ADD CONSTRAINT organizational_roles_role_category_check
CHECK (role_category IN ('staff', 'board'));