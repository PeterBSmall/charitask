-- ChariTask: Functional Role Credential Requirements
-- Defines credentials required for each organization-owned Functional Role.
-- Requirements are matched by category and, optionally, credential name.

CREATE TABLE public.functional_role_credential_requirements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    functional_role_id UUID NOT NULL,

    credential_category TEXT NOT NULL,
    credential_name TEXT,
    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT functional_role_credential_requirements_category_check
        CHECK (
            credential_category IN (
                'certification',
                'license',
                'training',
                'background_check',
                'other'
            )
        ),

    CONSTRAINT functional_role_credential_requirements_name_check
        CHECK (
            credential_name IS NULL
            OR length(trim(credential_name)) > 0
        ),

    CONSTRAINT functional_role_credential_requirements_role_fkey
        FOREIGN KEY (organization_id, functional_role_id)
        REFERENCES public.functional_roles (organization_id, id)
        ON DELETE CASCADE
);

-- Prevent duplicate requirements, ignoring name capitalization and whitespace.
-- A NULL credential name means any credential in that category can satisfy
-- the requirement.
CREATE UNIQUE INDEX functional_role_credential_requirements_unique_idx
    ON public.functional_role_credential_requirements (
        organization_id,
        functional_role_id,
        credential_category,
        COALESCE(lower(trim(credential_name)), '')
    );

CREATE INDEX functional_role_credential_requirements_role_idx
    ON public.functional_role_credential_requirements (
        organization_id,
        functional_role_id
    );

-- Authorization follows the existing Functional Role permissions.
ALTER TABLE public.functional_role_credential_requirements
    ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT, UPDATE, DELETE
    ON public.functional_role_credential_requirements
    TO authenticated;

CREATE POLICY functional_role_credential_requirements_select_policy
ON public.functional_role_credential_requirements
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

CREATE POLICY functional_role_credential_requirements_insert_policy
ON public.functional_role_credential_requirements
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

CREATE POLICY functional_role_credential_requirements_update_policy
ON public.functional_role_credential_requirements
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

CREATE POLICY functional_role_credential_requirements_delete_policy
ON public.functional_role_credential_requirements
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
        'functionalrole.edit'
    )
);