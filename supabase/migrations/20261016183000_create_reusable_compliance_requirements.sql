-- ChariTask: Reusable Compliance Requirements
-- Additive migration: preserves the legacy role-specific table and records,
-- creates reusable organization-owned requirement definitions, seeds global
-- templates, and backfills/deduplicates definitions across roles.
--
-- This migration intentionally does NOT drop or modify
-- functional_role_credential_requirements. Application code can transition
-- incrementally, and the original rows remain available for rollback/audit.


-- ---------------------------------------------------------------------------
-- 1. Reusable requirement templates
--    Global ChariTask templates have organization_id NULL and is_system true.
--    Organization-specific templates may be added later with an organization_id.
-- ---------------------------------------------------------------------------
CREATE TABLE public.compliance_requirement_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NULL
        REFERENCES public.organizations(id) ON DELETE CASCADE,
    slug TEXT NOT NULL,
    name TEXT NOT NULL,
    requirement_type TEXT NOT NULL,
    credential_category TEXT NULL,
    description TEXT NULL,
    default_rules JSONB NOT NULL DEFAULT '{}'::jsonb,
    is_system BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT compliance_requirement_templates_name_check
        CHECK (length(trim(name)) > 0),
    CONSTRAINT compliance_requirement_templates_type_check
        CHECK (requirement_type IN (
            'certification_license',
            'background_check',
            'agreement_acknowledgement',
            'training',
            'medical_clearance'
        )),
    CONSTRAINT compliance_requirement_templates_category_check
        CHECK (
            credential_category IS NULL
            OR credential_category IN (
                'certification', 'license', 'training', 'background_check', 'other'
            )
        ),
    CONSTRAINT compliance_requirement_templates_rules_check
        CHECK (jsonb_typeof(default_rules) = 'object'),
    CONSTRAINT compliance_requirement_templates_scope_check
        CHECK ((organization_id IS NULL AND is_system = TRUE)
            OR organization_id IS NOT NULL)
);

-- Global rows use the literal scope 'system'; tenant-owned templates use their
-- organization UUID. UUID text cannot equal the word 'system'.
CREATE UNIQUE INDEX compliance_requirement_templates_scope_slug_idx
    ON public.compliance_requirement_templates (
        COALESCE(organization_id::text, 'system'), slug
    );

CREATE INDEX compliance_requirement_templates_active_idx
    ON public.compliance_requirement_templates (is_active, name);

ALTER TABLE public.compliance_requirement_templates ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE, DELETE
    ON public.compliance_requirement_templates TO authenticated;

CREATE POLICY compliance_requirement_templates_select_policy
ON public.compliance_requirement_templates
FOR SELECT TO authenticated
USING (
    (organization_id IS NULL AND is_system = TRUE)
    OR (
        organization_id IS NOT NULL
        AND public.has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'functionalrole.view'::text
        )
    )
);

CREATE POLICY compliance_requirement_templates_insert_policy
ON public.compliance_requirement_templates
FOR INSERT TO authenticated
WITH CHECK (
    organization_id IS NOT NULL
    AND is_system = FALSE
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
    )
);

CREATE POLICY compliance_requirement_templates_update_policy
ON public.compliance_requirement_templates
FOR UPDATE TO authenticated
USING (
    organization_id IS NOT NULL
    AND is_system = FALSE
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
    )
)
WITH CHECK (
    organization_id IS NOT NULL
    AND is_system = FALSE
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
    )
);

CREATE POLICY compliance_requirement_templates_delete_policy
ON public.compliance_requirement_templates
FOR DELETE TO authenticated
USING (
    organization_id IS NOT NULL
    AND is_system = FALSE
    AND public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
    )
);

-- Default rule JSON is a suggested starting point, not a legal/compliance
-- determination. Administrators will be able to customize rules per requirement.
INSERT INTO public.compliance_requirement_templates (
    organization_id, slug, name, requirement_type, credential_category,
    description, default_rules, is_system
)
VALUES
    (
        NULL, 'drivers-license', 'Driver''s License',
        'certification_license', 'license',
        'Track a driver''s license and, when applicable, its expiration date.',
        '{"expiration_mode":"expires","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":true,"require_approval":true,"track_expiration_date":true,"notifications":[{"days_before":90,"recipient":"person"},{"days_before":30,"recipient":"supervisor"}]}'::jsonb,
        TRUE
    ),
    (
        NULL, 'cori-background-check', 'CORI Background Check',
        'background_check', 'background_check',
        'Track completion and review status without storing sensitive report details in the requirement.',
        '{"expiration_mode":"optional","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":false,"require_approval":true,"track_expiration_date":false,"notifications":[]}'::jsonb,
        TRUE
    ),
    (
        NULL, 'first-aid-certification', 'First Aid Certification',
        'certification_license', 'certification',
        'Track first aid certification, supporting evidence, and renewal when required.',
        '{"expiration_mode":"expires","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":true,"require_approval":true,"track_expiration_date":true,"notifications":[{"days_before":90,"recipient":"person"},{"days_before":30,"recipient":"supervisor"}]}'::jsonb,
        TRUE
    ),
    (
        NULL, 'cpr-certification', 'CPR Certification',
        'certification_license', 'certification',
        'Track CPR certification, supporting evidence, and renewal when required.',
        '{"expiration_mode":"expires","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":true,"require_approval":true,"track_expiration_date":true,"notifications":[{"days_before":90,"recipient":"person"},{"days_before":30,"recipient":"supervisor"}]}'::jsonb,
        TRUE
    ),
    (
        NULL, 'volunteer-agreement', 'Volunteer Agreement',
        'agreement_acknowledgement', NULL,
        'Track acceptance and the version of the volunteer agreement acknowledged.',
        '{"expiration_mode":"never_expires","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":false,"require_approval":false,"track_expiration_date":false,"notifications":[]}'::jsonb,
        TRUE
    ),
    (
        NULL, 'confidentiality-agreement', 'Confidentiality Agreement',
        'agreement_acknowledgement', NULL,
        'Track acknowledgment, version, acceptance date, and signed evidence when applicable.',
        '{"expiration_mode":"never_expires","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":false,"require_approval":false,"track_expiration_date":false,"notifications":[]}'::jsonb,
        TRUE
    ),
    (
        NULL, 'dot-physical', 'DOT Physical',
        'medical_clearance', NULL,
        'Track medical clearance status and applicable review or expiration dates.',
        '{"expiration_mode":"expires","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":true,"require_approval":true,"track_expiration_date":true,"notifications":[{"days_before":90,"recipient":"person"},{"days_before":30,"recipient":"supervisor"}]}'::jsonb,
        TRUE
    ),
    (
        NULL, 'lift-certification-medical-clearance', 'Lift Certification',
        'medical_clearance', NULL,
        'Track required lift-related clearance or certification and its review dates.',
        '{"expiration_mode":"optional","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":true,"require_approval":true,"track_expiration_date":true,"notifications":[]}'::jsonb,
        TRUE
    ),
    (
        NULL, 'medical-release', 'Medical Release',
        'medical_clearance', NULL,
        'Track completion and review of an applicable medical release.',
        '{"expiration_mode":"optional","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":true,"require_approval":true,"track_expiration_date":false,"notifications":[]}'::jsonb,
        TRUE
    ),
    (
        NULL, 'health-screening', 'Health Screening',
        'medical_clearance', NULL,
        'Track required screening completion and any applicable review date.',
        '{"expiration_mode":"optional","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":false,"require_approval":true,"track_expiration_date":false,"notifications":[]}'::jsonb,
        TRUE
    )
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------------
-- 2. Reusable organization-owned requirement definitions
-- ---------------------------------------------------------------------------
CREATE TABLE public.compliance_requirements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL
        REFERENCES public.organizations(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    requirement_type TEXT NOT NULL,
    -- Internal matching hint. The UI will present Requirement Type only.
    -- It remains nullable for agreements and new requirement types that do not
    -- map directly to the legacy person_credentials.category field.
    credential_category TEXT NULL,
    description TEXT NULL,
    rules JSONB NOT NULL DEFAULT '{}'::jsonb,
    source_template_id UUID NULL
        REFERENCES public.compliance_requirement_templates(id) ON DELETE SET NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT compliance_requirements_org_id_id_unique
        UNIQUE (organization_id, id),
    CONSTRAINT compliance_requirements_name_check
        CHECK (length(trim(name)) > 0),
    CONSTRAINT compliance_requirements_type_check
        CHECK (requirement_type IN (
            'certification_license',
            'background_check',
            'agreement_acknowledgement',
            'training',
            'medical_clearance',
            -- Retained only to represent legacy rows whose category was 'other'.
            -- New UI creation must not expose this as a selectable type.
            'other_legacy'
        )),
    CONSTRAINT compliance_requirements_category_check
        CHECK (
            credential_category IS NULL
            OR credential_category IN (
                'certification', 'license', 'training', 'background_check', 'other'
            )
        ),
    CONSTRAINT compliance_requirements_rules_check
        CHECK (jsonb_typeof(rules) = 'object')
);

CREATE UNIQUE INDEX compliance_requirements_identity_unique_idx
    ON public.compliance_requirements (
        organization_id,
        requirement_type,
        COALESCE(credential_category, ''),
        lower(trim(name)),
        lower(trim(COALESCE(description, '')))
    );

CREATE INDEX compliance_requirements_org_active_idx
    ON public.compliance_requirements (organization_id, is_active, name);

CREATE INDEX compliance_requirements_source_template_idx
    ON public.compliance_requirements (source_template_id)
    WHERE source_template_id IS NOT NULL;

ALTER TABLE public.compliance_requirements ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE, DELETE
    ON public.compliance_requirements TO authenticated;

CREATE POLICY compliance_requirements_select_policy
ON public.compliance_requirements
FOR SELECT TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.view'::text
    )
);

CREATE POLICY compliance_requirements_insert_policy
ON public.compliance_requirements
FOR INSERT TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
    )
);

CREATE POLICY compliance_requirements_update_policy
ON public.compliance_requirements
FOR UPDATE TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
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
        'functionalrole.edit'::text
    )
);

CREATE POLICY compliance_requirements_delete_policy
ON public.compliance_requirements
FOR DELETE TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
    )
);

-- ---------------------------------------------------------------------------
-- 3. Many-to-many relationship: one requirement can apply to many roles
-- ---------------------------------------------------------------------------
CREATE TABLE public.functional_role_compliance_requirements (
    organization_id UUID NOT NULL,
    functional_role_id UUID NOT NULL,
    compliance_requirement_id UUID NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT functional_role_compliance_requirements_pk
        PRIMARY KEY (organization_id, functional_role_id, compliance_requirement_id),
    CONSTRAINT functional_role_compliance_requirements_role_fkey
        FOREIGN KEY (organization_id, functional_role_id)
        REFERENCES public.functional_roles (organization_id, id)
        ON DELETE CASCADE,
    CONSTRAINT functional_role_compliance_requirements_requirement_fkey
        FOREIGN KEY (organization_id, compliance_requirement_id)
        REFERENCES public.compliance_requirements (organization_id, id)
        ON DELETE CASCADE
);

CREATE INDEX functional_role_compliance_requirements_requirement_idx
    ON public.functional_role_compliance_requirements (
        organization_id, compliance_requirement_id
    );

ALTER TABLE public.functional_role_compliance_requirements ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE, DELETE
    ON public.functional_role_compliance_requirements TO authenticated;

CREATE POLICY functional_role_compliance_requirements_select_policy
ON public.functional_role_compliance_requirements
FOR SELECT TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.view'::text
    )
);

CREATE POLICY functional_role_compliance_requirements_insert_policy
ON public.functional_role_compliance_requirements
FOR INSERT TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
    )
);

CREATE POLICY functional_role_compliance_requirements_update_policy
ON public.functional_role_compliance_requirements
FOR UPDATE TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
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
        'functionalrole.edit'::text
    )
);

CREATE POLICY functional_role_compliance_requirements_delete_policy
ON public.functional_role_compliance_requirements
FOR DELETE TO authenticated
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'functionalrole.edit'::text
    )
);

-- ---------------------------------------------------------------------------
-- 4. Backfill one reusable definition per identical legacy requirement
--    and link every existing role to that definition.
--
-- Legacy rows are NOT deleted. The lowest UUID in each normalized group is
-- reused as the new requirement ID; every legacy role association is copied.
-- ---------------------------------------------------------------------------
WITH legacy_normalized AS (
    SELECT
        old.id,
        old.organization_id,
        old.functional_role_id,
        old.credential_category,
        CASE old.credential_category
            WHEN 'background_check' THEN 'background_check'
            WHEN 'training' THEN 'training'
            WHEN 'other' THEN 'other_legacy'
            ELSE 'certification_license'
        END AS requirement_type,
        COALESCE(
            NULLIF(trim(old.credential_name), ''),
            CASE old.credential_category
                WHEN 'certification' THEN 'Certification (any qualifying credential)'
                WHEN 'license' THEN 'License (any qualifying credential)'
                WHEN 'training' THEN 'Training (any qualifying credential)'
                WHEN 'background_check' THEN 'Background Check (any qualifying record)'
                ELSE 'Other Credential (any qualifying record)'
            END
        ) AS requirement_name,
        old.description,
        old.created_at,
        old.updated_at
    FROM public.functional_role_credential_requirements old
), canonical AS (
    SELECT DISTINCT ON (
        organization_id,
        requirement_type,
        credential_category,
        lower(trim(requirement_name)),
        lower(trim(COALESCE(description, '')))
    )
        id,
        organization_id,
        requirement_type,
        credential_category,
        requirement_name,
        description,
        created_at,
        updated_at
    FROM legacy_normalized
    ORDER BY
        organization_id,
        requirement_type,
        credential_category,
        lower(trim(requirement_name)),
        lower(trim(COALESCE(description, ''))),
        id
)
INSERT INTO public.compliance_requirements (
    id, organization_id, name, requirement_type, credential_category,
    description, rules, source_template_id, is_active, created_at, updated_at
)
SELECT
    canonical.id,
    canonical.organization_id,
    canonical.requirement_name,
    canonical.requirement_type,
    canonical.credential_category,
    canonical.description,
    '{"expiration_mode":"optional","renewal_period_value":null,"renewal_period_unit":"years","require_document_upload":false,"require_approval":false,"track_expiration_date":true,"notifications":[]}'::jsonb,
    NULL,
    TRUE,
    canonical.created_at,
    canonical.updated_at
FROM canonical
ON CONFLICT (id) DO NOTHING;

WITH legacy_normalized AS (
    SELECT
        old.id,
        old.organization_id,
        old.functional_role_id,
        old.credential_category,
        CASE old.credential_category
            WHEN 'background_check' THEN 'background_check'
            WHEN 'training' THEN 'training'
            WHEN 'other' THEN 'other_legacy'
            ELSE 'certification_license'
        END AS requirement_type,
        COALESCE(
            NULLIF(trim(old.credential_name), ''),
            CASE old.credential_category
                WHEN 'certification' THEN 'Certification (any qualifying credential)'
                WHEN 'license' THEN 'License (any qualifying credential)'
                WHEN 'training' THEN 'Training (any qualifying credential)'
                WHEN 'background_check' THEN 'Background Check (any qualifying record)'
                ELSE 'Other Credential (any qualifying record)'
            END
        ) AS requirement_name,
        old.description
    FROM public.functional_role_credential_requirements old
)
INSERT INTO public.functional_role_compliance_requirements (
    organization_id, functional_role_id, compliance_requirement_id, is_required
)
SELECT
    legacy.organization_id,
    legacy.functional_role_id,
    requirement.id,
    TRUE
FROM legacy_normalized legacy
JOIN public.compliance_requirements requirement
    ON requirement.organization_id = legacy.organization_id
   AND requirement.requirement_type = legacy.requirement_type
   AND requirement.credential_category IS NOT DISTINCT FROM legacy.credential_category
   AND lower(trim(requirement.name)) = lower(trim(legacy.requirement_name))
   AND lower(trim(COALESCE(requirement.description, ''))) =
       lower(trim(COALESCE(legacy.description, '')))
ON CONFLICT (organization_id, functional_role_id, compliance_requirement_id)
DO NOTHING;
