-- ChariTask: Protected personal details
-- Stores date of birth and information-provider details separately
-- from ordinary People records.

-- 1. Define dedicated permissions.
INSERT INTO public.permissions (
    key,
    name,
    description,
    module
)
VALUES
(
    'people.personal_details.view',
    'View Personal Details',
    'View sensitive personal details, including date of birth and information-provider details.',
    'people'
),
(
    'people.personal_details.manage',
    'Manage Personal Details',
    'Create and update protected personal details, including date of birth and information-provider details.',
    'people'
)
ON CONFLICT (key) DO NOTHING;


-- 2. Create the protected details table.
CREATE TABLE public.person_private_details (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,

    date_of_birth DATE,

    information_provider_type TEXT NOT NULL
        DEFAULT 'organization_staff'
        CHECK (
            information_provider_type IN (
                'self',
                'parent_guardian',
                'authorized_representative',
                'organization_staff'
            )
        ),

    provider_name TEXT,
    provider_relationship TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_private_details_org_person_unique
        UNIQUE (organization_id, person_id),

    CONSTRAINT person_private_details_person_fk
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id)
        ON DELETE CASCADE,

    CONSTRAINT person_private_details_provider_name_check
        CHECK (
            information_provider_type NOT IN (
                'parent_guardian',
                'authorized_representative'
            )
            OR NULLIF(BTRIM(provider_name), '') IS NOT NULL
        )
);

CREATE INDEX person_private_details_organization_idx
    ON public.person_private_details (organization_id);

ALTER TABLE public.person_private_details
    ENABLE ROW LEVEL SECURITY;


-- 3. Read access requires the dedicated view or manage permission.
CREATE POLICY person_private_details_select_policy
ON public.person_private_details
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
        'people.personal_details.view'::TEXT
    )
    OR has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'people.personal_details.manage'::TEXT
    )
);


-- 4. Only users with the manage permission can insert.
CREATE POLICY person_private_details_insert_policy
ON public.person_private_details
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
        'people.personal_details.manage'::TEXT
    )
);


-- 5. Only users with the manage permission can update.
CREATE POLICY person_private_details_update_policy
ON public.person_private_details
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
        'people.personal_details.manage'::TEXT
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
        'people.personal_details.manage'::TEXT
    )
);


-- 6. Only users with the manage permission can delete.
CREATE POLICY person_private_details_delete_policy
ON public.person_private_details
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
        'people.personal_details.manage'::TEXT
    )
);


-- 7. Automatically maintain updated_at.
CREATE OR REPLACE FUNCTION public.set_person_private_details_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $function$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$function$;

CREATE TRIGGER person_private_details_updated_at_trigger
BEFORE UPDATE ON public.person_private_details
FOR EACH ROW
EXECUTE FUNCTION public.set_person_private_details_updated_at();


-- 8. Grant the new permissions to existing active System Administrators.
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
        'people.personal_details.view',
        'people.personal_details.manage'
    )
WHERE fr.name = 'System Administrator'
  AND fr.status = 'active'
ON CONFLICT (
    organization_id,
    functional_role_id,
    permission_id
)
DO NOTHING;


-- 9. Extend the existing System Administrator permission trigger.
-- Preserve its existing credential grants while adding the two
-- personal-details permissions for future role assignments.

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
            'credentials.background_checks.manage',
            'people.personal_details.view',
            'people.personal_details.manage'
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
