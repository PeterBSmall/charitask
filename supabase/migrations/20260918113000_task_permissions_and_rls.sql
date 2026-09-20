-- ChariTask Foundation: Task Permissions and RLS
--
-- Adds organization-scoped Task permissions and authorization.

-- ============================================================
-- 1. Task permissions
-- ============================================================

INSERT INTO public.permissions (
    key,
    name,
    description,
    module
)
VALUES
(
    'tasks.view',
    'View Tasks',
    'View organization workspace tasks.',
    'tasks'
),
(
    'tasks.create',
    'Create Tasks',
    'Create workspace tasks.',
    'tasks'
),
(
    'tasks.edit',
    'Edit Tasks',
    'Edit workspace task information.',
    'tasks'
),
(
    'tasks.delete',
    'Delete Tasks',
    'Archive workspace tasks.',
    'tasks'
)
ON CONFLICT (key) DO NOTHING;


-- ============================================================
-- 2. Enable Row Level Security
-- ============================================================

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- 3. SELECT policy
-- ============================================================

DROP POLICY IF EXISTS "tasks_select_policy"
ON public.tasks;

CREATE POLICY "tasks_select_policy"
ON public.tasks
FOR SELECT
TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'tasks.view'
    )
);


-- ============================================================
-- 4. INSERT policy
-- ============================================================

DROP POLICY IF EXISTS "tasks_insert_policy"
ON public.tasks;

CREATE POLICY "tasks_insert_policy"
ON public.tasks
FOR INSERT
TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'tasks.create'
    )
);


-- ============================================================
-- 5. UPDATE policy
-- ============================================================

DROP POLICY IF EXISTS "tasks_update_policy"
ON public.tasks;

CREATE POLICY "tasks_update_policy"
ON public.tasks
FOR UPDATE
TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'tasks.edit'
    )
)
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'tasks.edit'
    )
);


-- ============================================================
-- 6. DELETE policy
-- ============================================================

DROP POLICY IF EXISTS "tasks_delete_policy"
ON public.tasks;

CREATE POLICY "tasks_delete_policy"
ON public.tasks
FOR DELETE
TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'tasks.delete'
    )
);
