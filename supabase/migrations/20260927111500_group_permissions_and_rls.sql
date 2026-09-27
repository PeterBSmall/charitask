-- ChariTask Foundation: Group Permissions and RLS
--
-- Adds organization-scoped Group permissions and authorization.
--
-- Group access is always evaluated within the Group's organization.
-- Membership management is separately protected by groups.manage.

-- ============================================================
-- 1. Organization-scoped permission helper
-- ============================================================

CREATE OR REPLACE FUNCTION public.has_organization_permission(
    p_person_id UUID,
    p_organization_id UUID,
    p_permission_key TEXT
)
RETURNS BOOLEAN
LANGUAGE SQL
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.functional_role_assignments fra
        JOIN public.functional_roles fr
            ON fr.organization_id = fra.organization_id
            AND fr.id = fra.functional_role_id
        JOIN public.functional_role_permissions frp
            ON frp.organization_id = fra.organization_id
            AND frp.functional_role_id = fra.functional_role_id
        JOIN public.permissions p
            ON p.id = frp.permission_id
        WHERE fra.organization_id = p_organization_id
          AND fra.person_id = p_person_id
          AND fra.status = 'active'
          AND fr.status = 'active'
          AND p.key = p_permission_key
    );
$$;


-- ============================================================
-- 2. Group permissions
-- ============================================================

INSERT INTO public.permissions (
    key,
    name,
    description,
    module
)
VALUES
(
    'groups.view',
    'View Groups',
    'View organization groups and group membership information.',
    'groups'
),
(
    'groups.create',
    'Create Groups',
    'Create organization groups.',
    'groups'
),
(
    'groups.edit',
    'Edit Groups',
    'Edit organization group information.',
    'groups'
),
(
    'groups.delete',
    'Delete Groups',
    'Archive organization groups.',
    'groups'
),
(
    'groups.manage',
    'Manage Groups',
    'Manage group membership and other group management operations.',
    'groups'
)
ON CONFLICT (key) DO NOTHING;


-- ============================================================
-- 3. Enable Row Level Security
-- ============================================================

ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.group_memberships ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- 4. GROUP SELECT
-- ============================================================

DROP POLICY IF EXISTS "groups_select_policy"
ON public.groups;

CREATE POLICY "groups_select_policy"
ON public.groups
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
        'groups.view'
    )
);


-- ============================================================
-- 5. GROUP INSERT
-- ============================================================

DROP POLICY IF EXISTS "groups_insert_policy"
ON public.groups;

CREATE POLICY "groups_insert_policy"
ON public.groups
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
        'groups.create'
    )
);


-- ============================================================
-- 6. GROUP UPDATE
-- ============================================================

DROP POLICY IF EXISTS "groups_update_policy"
ON public.groups;

CREATE POLICY "groups_update_policy"
ON public.groups
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
        'groups.edit'
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
        'groups.edit'
    )
);


-- ============================================================
-- 7. GROUP DELETE
-- ============================================================

DROP POLICY IF EXISTS "groups_delete_policy"
ON public.groups;

CREATE POLICY "groups_delete_policy"
ON public.groups
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
        'groups.delete'
    )
);


-- ============================================================
-- 8. GROUP MEMBERSHIP SELECT
-- ============================================================

DROP POLICY IF EXISTS "group_memberships_select_policy"
ON public.group_memberships;

CREATE POLICY "group_memberships_select_policy"
ON public.group_memberships
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
        'groups.view'
    )
);


-- ============================================================
-- 9. GROUP MEMBERSHIP INSERT
-- ============================================================

DROP POLICY IF EXISTS "group_memberships_insert_policy"
ON public.group_memberships;

CREATE POLICY "group_memberships_insert_policy"
ON public.group_memberships
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
        'groups.manage'
    )
);


-- ============================================================
-- 10. GROUP MEMBERSHIP UPDATE
-- ============================================================

DROP POLICY IF EXISTS "group_memberships_update_policy"
ON public.group_memberships;

CREATE POLICY "group_memberships_update_policy"
ON public.group_memberships
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
        'groups.manage'
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
        'groups.manage'
    )
);


-- ============================================================
-- 11. GROUP MEMBERSHIP DELETE
-- ============================================================

DROP POLICY IF EXISTS "group_memberships_delete_policy"
ON public.group_memberships;

CREATE POLICY "group_memberships_delete_policy"
ON public.group_memberships
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
        'groups.manage'
    )
);