-- ChariTask Foundation: Functional Role Permissions and RLS
--
-- Adds organization-scoped Functional Role permissions and authorization.
--
-- Functional Role access is evaluated within the Functional Role's
-- organization.
--
-- Catalog administration:
--   functionalrole.view
--   functionalrole.create
--   functionalrole.edit
--   functionalrole.delete
--
-- Assignment and role-permission management:
--   functionalrole.manage


-- ============================================================
-- 1. Functional Role permissions
-- ============================================================

INSERT INTO public.permissions (
    key,
    name,
    description,
    module
)
VALUES
(
    'functionalrole.view',
    'View Functional Roles',
    'View organization functional roles, categories, and role assignments.',
    'functionalrole'
),
(
    'functionalrole.create',
    'Create Functional Roles',
    'Create organization functional roles.',
    'functionalrole'
),
(
    'functionalrole.edit',
    'Edit Functional Roles',
    'Edit organization functional roles and categories.',
    'functionalrole'
),
(
    'functionalrole.delete',
    'Delete Functional Roles',
    'Archive organization functional roles and categories.',
    'functionalrole'
),
(
    'functionalrole.manage',
    'Manage Functional Roles',
    'Manage functional role assignments and role permissions.',
    'functionalrole'
)
ON CONFLICT (key) DO NOTHING;


-- ============================================================
-- 2. Enable Row Level Security
-- ============================================================

ALTER TABLE public.functional_roles
    ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.functional_role_categories
    ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.functional_role_assignments
    ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.functional_role_permissions
    ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- 3. FUNCTIONAL ROLE SELECT
-- ============================================================

DROP POLICY IF EXISTS "functional_roles_select_policy"
ON public.functional_roles;

CREATE POLICY "functional_roles_select_policy"
ON public.functional_roles
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
        'functionalrole.view'
    )
);


-- ============================================================
-- 4. FUNCTIONAL ROLE INSERT
-- ============================================================

DROP POLICY IF EXISTS "functional_roles_insert_policy"
ON public.functional_roles;

CREATE POLICY "functional_roles_insert_policy"
ON public.functional_roles
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
        'functionalrole.create'
    )
);


-- ============================================================
-- 5. FUNCTIONAL ROLE UPDATE
-- ============================================================

DROP POLICY IF EXISTS "functional_roles_update_policy"
ON public.functional_roles;

CREATE POLICY "functional_roles_update_policy"
ON public.functional_roles
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
        'functionalrole.edit'
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
        'functionalrole.edit'
    )
);


-- ============================================================
-- 6. FUNCTIONAL ROLE DELETE
-- ============================================================

DROP POLICY IF EXISTS "functional_roles_delete_policy"
ON public.functional_roles;

CREATE POLICY "functional_roles_delete_policy"
ON public.functional_roles
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
        'functionalrole.delete'
    )
);


-- ============================================================
-- 7. FUNCTIONAL ROLE CATEGORY SELECT
-- ============================================================

DROP POLICY IF EXISTS "functional_role_categories_select_policy"
ON public.functional_role_categories;

CREATE POLICY "functional_role_categories_select_policy"
ON public.functional_role_categories
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
        'functionalrole.view'
    )
);


-- ============================================================
-- 8. FUNCTIONAL ROLE CATEGORY INSERT
-- ============================================================

DROP POLICY IF EXISTS "functional_role_categories_insert_policy"
ON public.functional_role_categories;

CREATE POLICY "functional_role_categories_insert_policy"
ON public.functional_role_categories
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
        'functionalrole.edit'
    )
);


-- ============================================================
-- 9. FUNCTIONAL ROLE CATEGORY UPDATE
-- ============================================================

DROP POLICY IF EXISTS "functional_role_categories_update_policy"
ON public.functional_role_categories;

CREATE POLICY "functional_role_categories_update_policy"
ON public.functional_role_categories
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
        'functionalrole.edit'
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
        'functionalrole.edit'
    )
);


-- ============================================================
-- 10. FUNCTIONAL ROLE CATEGORY DELETE
-- ============================================================

DROP POLICY IF EXISTS "functional_role_categories_delete_policy"
ON public.functional_role_categories;

CREATE POLICY "functional_role_categories_delete_policy"
ON public.functional_role_categories
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
        'functionalrole.delete'
    )
);


-- ============================================================
-- 11. FUNCTIONAL ROLE ASSIGNMENT SELECT
-- ============================================================

DROP POLICY IF EXISTS "functional_role_assignments_select_policy"
ON public.functional_role_assignments;

CREATE POLICY "functional_role_assignments_select_policy"
ON public.functional_role_assignments
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
        'functionalrole.view'
    )
);


-- ============================================================
-- 12. FUNCTIONAL ROLE ASSIGNMENT INSERT
-- ============================================================

DROP POLICY IF EXISTS "functional_role_assignments_insert_policy"
ON public.functional_role_assignments;

CREATE POLICY "functional_role_assignments_insert_policy"
ON public.functional_role_assignments
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
        'functionalrole.manage'
    )
);


-- ============================================================
-- 13. FUNCTIONAL ROLE ASSIGNMENT UPDATE
-- ============================================================

DROP POLICY IF EXISTS "functional_role_assignments_update_policy"
ON public.functional_role_assignments;

CREATE POLICY "functional_role_assignments_update_policy"
ON public.functional_role_assignments
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
        'functionalrole.manage'
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
        'functionalrole.manage'
    )
);


-- ============================================================
-- 14. FUNCTIONAL ROLE ASSIGNMENT DELETE
-- ============================================================

DROP POLICY IF EXISTS "functional_role_assignments_delete_policy"
ON public.functional_role_assignments;

CREATE POLICY "functional_role_assignments_delete_policy"
ON public.functional_role_assignments
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
        'functionalrole.manage'
    )
);


-- ============================================================
-- 15. FUNCTIONAL ROLE PERMISSION SELECT
-- ============================================================

DROP POLICY IF EXISTS "functional_role_permissions_select_policy"
ON public.functional_role_permissions;

CREATE POLICY "functional_role_permissions_select_policy"
ON public.functional_role_permissions
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
        'functionalrole.view'
    )
);


-- ============================================================
-- 16. FUNCTIONAL ROLE PERMISSION INSERT
-- ============================================================

DROP POLICY IF EXISTS "functional_role_permissions_insert_policy"
ON public.functional_role_permissions;

CREATE POLICY "functional_role_permissions_insert_policy"
ON public.functional_role_permissions
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
        'functionalrole.manage'
    )
);


-- ============================================================
-- 17. FUNCTIONAL ROLE PERMISSION DELETE
-- ============================================================

DROP POLICY IF EXISTS "functional_role_permissions_delete_policy"
ON public.functional_role_permissions;

CREATE POLICY "functional_role_permissions_delete_policy"
ON public.functional_role_permissions
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
        'functionalrole.manage'
    )
);
