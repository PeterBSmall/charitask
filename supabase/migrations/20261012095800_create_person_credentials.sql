
-- ChariTask: Volunteer credentials and compliance
-- Categories, credential statuses, organization-scoped integrity,
-- and permissions for ordinary credentials versus background checks.

-- ============================================================
-- 1. PERMISSIONS
-- ============================================================

INSERT INTO public.permissions (
    key,
    name,
    description,
    module
)
VALUES
(
    'credentials.view',
    'View Credentials',
    'View certifications, licenses, training, and other credentials.',
    'people'
),
(
    'credentials.manage',
    'Manage Credentials',
    'Create, edit, and remove credentials.',
    'people'
),
(
    'credentials.background_checks.view',
    'View Background Check Status',
    'View background-check status and relevant dates.',
    'people'
),
(
    'credentials.background_checks.manage',
    'Manage Background Checks',
    'Manage background-check status and relevant dates.',
    'people'
)
ON CONFLICT (key) DO NOTHING;


-- ============================================================
-- 2. CREDENTIALS TABLE
-- ============================================================

CREATE TABLE public.person_credentials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,

    category TEXT NOT NULL,
    credential_name TEXT NOT NULL,
    issuing_organization TEXT,

    issue_date DATE,
    expiration_date DATE,

    -- Status depends on category:
    -- Ordinary credentials: pending, verified, rejected
    -- Background checks: pending, cleared, review_required, not_cleared
    status TEXT NOT NULL DEFAULT 'pending',

    reviewed_at TIMESTAMPTZ,
    reviewed_by_person_id UUID,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_credentials_category_check
        CHECK (
            category IN (
                'certification',
                'license',
                'training',
                'background_check',
                'other'
            )
        ),

    CONSTRAINT person_credentials_name_check
        CHECK (length(trim(credential_name)) > 0),

    CONSTRAINT person_credentials_status_check
        CHECK (
            (
                category = 'background_check'
                AND status IN (
                    'pending',
                    'cleared',
                    'review_required',
                    'not_cleared'
                )
            )
            OR
            (
                category <> 'background_check'
                AND status IN (
                    'pending',
                    'verified',
                    'rejected'
                )
            )
        ),

    CONSTRAINT person_credentials_dates_check
        CHECK (
            expiration_date IS NULL
            OR issue_date IS NULL
            OR expiration_date >= issue_date
        ),

    CONSTRAINT person_credentials_organization_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT person_credentials_organization_reviewer_fkey
        FOREIGN KEY (organization_id, reviewed_by_person_id)
        REFERENCES public.persons (organization_id, id)
);

CREATE INDEX person_credentials_person_idx
    ON public.person_credentials (organization_id, person_id);

CREATE INDEX person_credentials_expiration_idx
    ON public.person_credentials (organization_id, expiration_date)
    WHERE expiration_date IS NOT NULL;

CREATE INDEX person_credentials_category_status_idx
    ON public.person_credentials (
        organization_id,
        category,
        status
    );


-- ============================================================
-- 3. ROW-LEVEL SECURITY
-- ============================================================

ALTER TABLE public.person_credentials
    ENABLE ROW LEVEL SECURITY;


-- Reading any credential requires credentials.view.
-- Background-check records additionally require the specific
-- background-check viewing permission.

CREATE POLICY person_credentials_select_policy
ON public.person_credentials
FOR SELECT
TO authenticated
USING (
    has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.view'::text
    )
    AND (
        category <> 'background_check'
        OR has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.background_checks.view'::text
        )
    )
);


-- Creating a credential requires credentials.manage.
-- Creating a background-check record also requires the
-- separate background-check management permission.

CREATE POLICY person_credentials_insert_policy
ON public.person_credentials
FOR INSERT
TO authenticated
WITH CHECK (
    has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.manage'::text
    )
    AND (
        category <> 'background_check'
        OR has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.background_checks.manage'::text
        )
    )
);


CREATE POLICY person_credentials_update_policy
ON public.person_credentials
FOR UPDATE
TO authenticated
USING (
    has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.manage'::text
    )
    AND (
        category <> 'background_check'
        OR has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.background_checks.manage'::text
        )
    )
)
WITH CHECK (
    has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.manage'::text
    )
    AND (
        category <> 'background_check'
        OR has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.background_checks.manage'::text
        )
    )
);


CREATE POLICY person_credentials_delete_policy
ON public.person_credentials
FOR DELETE
TO authenticated
USING (
    has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.manage'::text
    )
    AND (
        category <> 'background_check'
        OR has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.background_checks.manage'::text
        )
    )
);


-- ============================================================
-- 4. GRANT PERMISSIONS TO EXISTING SYSTEM ADMINISTRATORS
-- ============================================================

INSERT INTO public.functional_role_permissions (
    organization_id,
    functional_role_id,
    permission_id
)
SELECT
    fr.organization_id,
    fr.id,
    p.id
FROM public.functional_roles fr
JOIN public.permissions p
    ON p.key IN (
        'credentials.view',
        'credentials.manage',
        'credentials.background_checks.view',
        'credentials.background_checks.manage'
    )
WHERE fr.name = 'System Administrator'
  AND fr.status = 'active'
ON CONFLICT (organization_id, functional_role_id, permission_id)
DO NOTHING;


-- ============================================================

-- ============================================================
-- 5. FUTURE ORGANIZATION PROVISIONING
-- ============================================================
-- Automatically grant Credentials permissions when a
-- System Administrator functional-role assignment is active.
-- This preserves the existing provision_initial_organization()
-- function and its current nine-argument signature.

CREATE OR REPLACE FUNCTION
public.grant_system_admin_credential_permissions()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $function$
BEGIN
    IF NEW.status IS DISTINCT FROM 'active' THEN
        RETURN NEW;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM public.functional_roles fr
        LEFT JOIN public.functional_role_catalog_roles rcr
            ON rcr.id = fr.catalog_role_id
        WHERE fr.organization_id = NEW.organization_id
          AND fr.id = NEW.functional_role_id
          AND fr.status = 'active'
          AND (
              fr.slug = 'system-administrator'
              OR fr.name = 'System Administrator'
              OR rcr.slug = 'system-administrator'
          )
    ) THEN
        INSERT INTO public.functional_role_permissions (
            organization_id,
            functional_role_id,
            permission_id
        )
        SELECT
            NEW.organization_id,
            NEW.functional_role_id,
            p.id
        FROM public.permissions p
        WHERE p.key IN (
            'credentials.view',
            'credentials.manage',
            'credentials.background_checks.view',
            'credentials.background_checks.manage'
        )
        ON CONFLICT (
            organization_id,
            functional_role_id,
            permission_id
        )
        DO NOTHING;
    END IF;

    RETURN NEW;
END;
$function$;


DROP TRIGGER IF EXISTS
    grant_system_admin_credential_permissions_trigger
ON public.functional_role_assignments;

CREATE TRIGGER
    grant_system_admin_credential_permissions_trigger
AFTER INSERT OR UPDATE OF status, functional_role_id
ON public.functional_role_assignments
FOR EACH ROW
EXECUTE FUNCTION
    public.grant_system_admin_credential_permissions();
