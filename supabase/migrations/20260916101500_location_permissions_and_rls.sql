-- ChariTask Foundation: Location Permissions and RLS
--
-- Adds organization-scoped Location permissions and authorization.
--
-- Location access is always evaluated within the Location's
-- organization. This prevents a person's permission in one
-- organization from granting access to another organization's data.

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
-- 2. Location permissions
-- ============================================================

INSERT INTO public.permissions (
    key,
    name,
    description,
    module
)
VALUES
(
    'locations.view',
    'View Locations',
    'View organization locations.',
    'locations'
),
(
    'locations.create',
    'Create Locations',
    'Create organization locations.',
    'locations'
),
(
    'locations.edit',
    'Edit Locations',
    'Edit organization location information.',
    'locations'
),
(
    'locations.delete',
    'Delete Locations',
    'Archive organization locations.',
    'locations'
)
ON CONFLICT (key) DO NOTHING;


-- ============================================================
-- 3. Enable Row Level Security
-- ============================================================

ALTER TABLE public.locations ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- 4. SELECT policy
-- ============================================================

DROP POLICY IF EXISTS "locations_select_policy"
ON public.locations;

CREATE POLICY "locations_select_policy"
ON public.locations
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
        'locations.view'
    )
);


-- ============================================================
-- 5. INSERT policy
-- ============================================================

DROP POLICY IF EXISTS "locations_insert_policy"
ON public.locations;

CREATE POLICY "locations_insert_policy"
ON public.locations
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
        'locations.create'
    )
);


-- ============================================================
-- 6. UPDATE policy
-- ============================================================

DROP POLICY IF EXISTS "locations_update_policy"
ON public.locations;

CREATE POLICY "locations_update_policy"
ON public.locations
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
        'locations.edit'
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
        'locations.edit'
    )
);


-- ============================================================
-- 7. DELETE policy
-- ============================================================

DROP POLICY IF EXISTS "locations_delete_policy"
ON public.locations;

CREATE POLICY "locations_delete_policy"
ON public.locations
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
        'locations.delete'
    )
);