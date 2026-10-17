-- ChariTask: Person-level agreement acknowledgements and medical-clearance records.
-- Additive migration. Does not alter or delete person_credentials or legacy requirements.
-- Keep medical-clearance records administrative: clearance status and dates only;
-- do not store diagnoses, detailed medical reports, or clinical notes here.

-- ---------------------------------------------------------------------------
-- 1. Agreement-version label and dedicated permissions.
-- ---------------------------------------------------------------------------
ALTER TABLE public.compliance_requirements
    ADD COLUMN version_label TEXT NOT NULL DEFAULT '1';

ALTER TABLE public.compliance_requirements
    ADD CONSTRAINT compliance_requirements_version_label_check
    CHECK (length(trim(version_label)) > 0);

INSERT INTO public.permissions (key, name, description, module)
VALUES
    (
        'compliance.agreements.view',
        'View Compliance Agreements',
        'View agreement acknowledgement status, accepted version, and relevant dates.',
        'compliance'
    ),
    (
        'compliance.agreements.manage',
        'Manage Compliance Agreements',
        'Create and update agreement acknowledgements and signed agreement records.',
        'compliance'
    ),
    (
        'compliance.medical_clearance.view',
        'View Medical Clearance Status',
        'View medical-clearance status and relevant dates without clinical details.',
        'compliance'
    ),
    (
        'compliance.medical_clearance.manage',
        'Manage Medical Clearance',
        'Create and update administrative medical-clearance status and relevant dates.',
        'compliance'
    )
ON CONFLICT (key) DO NOTHING;

-- ---------------------------------------------------------------------------
-- 2. Agreement acknowledgements.
-- One row represents a person's response to a particular requirement version.
-- Version snapshots are retained; use status updates rather than deleting history.
-- ---------------------------------------------------------------------------
CREATE TABLE public.person_compliance_agreement_acknowledgements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,
    compliance_requirement_id UUID NOT NULL,
    agreement_version TEXT NOT NULL DEFAULT '1',
    status TEXT NOT NULL DEFAULT 'pending',
    accepted_at TIMESTAMPTZ NULL,
    accepted_by_person_id UUID NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_compliance_agreement_ack_version_check
        CHECK (length(trim(agreement_version)) > 0),
    CONSTRAINT person_compliance_agreement_ack_status_check
        CHECK (status IN ('pending', 'accepted', 'declined', 'revoked')),
    CONSTRAINT person_compliance_agreement_ack_accepted_at_check
        CHECK (status <> 'accepted' OR accepted_at IS NOT NULL),
    CONSTRAINT person_compliance_agreement_ack_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),
    CONSTRAINT person_compliance_agreement_ack_requirement_fkey
        FOREIGN KEY (organization_id, compliance_requirement_id)
        REFERENCES public.compliance_requirements (organization_id, id),
    CONSTRAINT person_compliance_agreement_ack_accepted_by_fkey
        FOREIGN KEY (organization_id, accepted_by_person_id)
        REFERENCES public.persons (organization_id, id),
    CONSTRAINT person_compliance_agreement_ack_record_scope_unique
        UNIQUE (organization_id, person_id, id),
    CONSTRAINT person_compliance_agreement_ack_version_unique
        UNIQUE (organization_id, person_id, compliance_requirement_id, agreement_version)
);

CREATE INDEX person_compliance_agreement_ack_person_idx
    ON public.person_compliance_agreement_acknowledgements
        (organization_id, person_id, status);
CREATE INDEX person_compliance_agreement_ack_requirement_idx
    ON public.person_compliance_agreement_acknowledgements
        (organization_id, compliance_requirement_id, status);

ALTER TABLE public.person_compliance_agreement_acknowledgements ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE
    ON public.person_compliance_agreement_acknowledgements TO authenticated;

CREATE POLICY person_compliance_agreement_ack_select_policy
ON public.person_compliance_agreement_acknowledgements
FOR SELECT TO authenticated
USING (
    public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.agreements.view'::TEXT
    )
    OR public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.agreements.manage'::TEXT
    )
);

CREATE POLICY person_compliance_agreement_ack_insert_policy
ON public.person_compliance_agreement_acknowledgements
FOR INSERT TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.agreements.manage'::TEXT
    )
);

CREATE POLICY person_compliance_agreement_ack_update_policy
ON public.person_compliance_agreement_acknowledgements
FOR UPDATE TO authenticated
USING (
    public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.agreements.manage'::TEXT
    )
)
WITH CHECK (
    public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.agreements.manage'::TEXT
    )
);

-- ---------------------------------------------------------------------------
-- 3. Medical clearance records.
-- Store only the administrative outcome and dates. Do not store diagnoses,
-- treatment details, or clinical notes in this table.
-- ---------------------------------------------------------------------------
CREATE TABLE public.person_medical_clearance_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,
    compliance_requirement_id UUID NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    clearance_date DATE NULL,
    expiration_date DATE NULL,
    reviewed_at TIMESTAMPTZ NULL,
    reviewed_by_person_id UUID NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_medical_clearance_status_check
        CHECK (status IN ('pending', 'cleared', 'review_required', 'not_cleared')),
    CONSTRAINT person_medical_clearance_dates_check
        CHECK (expiration_date IS NULL OR clearance_date IS NULL OR expiration_date >= clearance_date),
    CONSTRAINT person_medical_clearance_cleared_date_check
        CHECK (status <> 'cleared' OR clearance_date IS NOT NULL),
    CONSTRAINT person_medical_clearance_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),
    CONSTRAINT person_medical_clearance_requirement_fkey
        FOREIGN KEY (organization_id, compliance_requirement_id)
        REFERENCES public.compliance_requirements (organization_id, id),
    CONSTRAINT person_medical_clearance_reviewer_fkey
        FOREIGN KEY (organization_id, reviewed_by_person_id)
        REFERENCES public.persons (organization_id, id),
    CONSTRAINT person_medical_clearance_record_scope_unique
        UNIQUE (organization_id, person_id, id)
);

CREATE INDEX person_medical_clearance_person_idx
    ON public.person_medical_clearance_records (organization_id, person_id, status);
CREATE INDEX person_medical_clearance_requirement_idx
    ON public.person_medical_clearance_records
        (organization_id, compliance_requirement_id, status);
CREATE INDEX person_medical_clearance_expiration_idx
    ON public.person_medical_clearance_records (organization_id, expiration_date)
    WHERE expiration_date IS NOT NULL;

ALTER TABLE public.person_medical_clearance_records ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE
    ON public.person_medical_clearance_records TO authenticated;

CREATE POLICY person_medical_clearance_select_policy
ON public.person_medical_clearance_records
FOR SELECT TO authenticated
USING (
    public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.medical_clearance.view'::TEXT
    )
    OR public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.medical_clearance.manage'::TEXT
    )
);

CREATE POLICY person_medical_clearance_insert_policy
ON public.person_medical_clearance_records
FOR INSERT TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.medical_clearance.manage'::TEXT
    )
);

CREATE POLICY person_medical_clearance_update_policy
ON public.person_medical_clearance_records
FOR UPDATE TO authenticated
USING (
    public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.medical_clearance.manage'::TEXT
    )
)
WITH CHECK (
    public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai
         WHERE pai.auth_user_id = auth.uid()),
        organization_id,
        'compliance.medical_clearance.manage'::TEXT
    )
);

-- ---------------------------------------------------------------------------
-- 4. Ensure records cannot be attached to the wrong requirement type.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.validate_person_compliance_record_requirement()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $function$
DECLARE
    v_requirement_type TEXT;
    v_requirement_version TEXT;
    v_expected_type TEXT;
BEGIN
    IF TG_TABLE_NAME = 'person_compliance_agreement_acknowledgements' THEN
        v_expected_type := 'agreement_acknowledgement';
    ELSIF TG_TABLE_NAME = 'person_medical_clearance_records' THEN
        v_expected_type := 'medical_clearance';
    ELSE
        RAISE EXCEPTION 'Unsupported table for Compliance record requirement validation.';
    END IF;

    SELECT cr.requirement_type, cr.version_label
      INTO v_requirement_type, v_requirement_version
      FROM public.compliance_requirements cr
     WHERE cr.organization_id = NEW.organization_id
       AND cr.id = NEW.compliance_requirement_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Compliance Requirement does not exist in this organization.'
            USING ERRCODE = '23503';
    END IF;

    IF v_requirement_type <> v_expected_type THEN
        RAISE EXCEPTION 'Requirement type % cannot be used for a % record.',
            v_requirement_type, TG_TABLE_NAME
            USING ERRCODE = '23514';
    END IF;

    -- The accepted version is a snapshot of the requirement definition at the
    -- time this acknowledgement is created or moved to another requirement.
    IF TG_TABLE_NAME = 'person_compliance_agreement_acknowledgements'
       AND (TG_OP = 'INSERT' OR NEW.compliance_requirement_id IS DISTINCT FROM OLD.compliance_requirement_id) THEN
        NEW.agreement_version := v_requirement_version;
    END IF;

    RETURN NEW;
END;
$function$;

CREATE TRIGGER person_compliance_agreement_requirement_type_trigger
BEFORE INSERT OR UPDATE OF organization_id, compliance_requirement_id
ON public.person_compliance_agreement_acknowledgements
FOR EACH ROW
EXECUTE FUNCTION public.validate_person_compliance_record_requirement();

CREATE TRIGGER person_medical_clearance_requirement_type_trigger
BEFORE INSERT OR UPDATE OF organization_id, compliance_requirement_id
ON public.person_medical_clearance_records
FOR EACH ROW
EXECUTE FUNCTION public.validate_person_compliance_record_requirement();

-- ---------------------------------------------------------------------------
-- 5. Private document metadata for signed agreements and clearance evidence.
-- Medical documents should contain clearance evidence only, not detailed
-- medical reports. Actual uploads use a separate private Storage bucket.
-- ---------------------------------------------------------------------------
INSERT INTO storage.buckets (
    id, name, public, file_size_limit, allowed_mime_types
)
VALUES (
    'person-compliance-record-documents',
    'person-compliance-record-documents',
    FALSE,
    10485760,
    ARRAY['application/pdf', 'image/jpeg', 'image/png']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
    public = FALSE,
    file_size_limit = 10485760,
    allowed_mime_types = ARRAY['application/pdf', 'image/jpeg', 'image/png']::TEXT[];

CREATE TABLE public.person_compliance_record_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,
    agreement_acknowledgement_id UUID NULL,
    medical_clearance_record_id UUID NULL,
    storage_path TEXT NOT NULL UNIQUE,
    file_name TEXT NOT NULL,
    content_type TEXT NOT NULL,
    file_size BIGINT NOT NULL,
    uploaded_by_person_id UUID NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_compliance_record_documents_one_parent_check
        CHECK (
            (agreement_acknowledgement_id IS NOT NULL AND medical_clearance_record_id IS NULL)
            OR
            (agreement_acknowledgement_id IS NULL AND medical_clearance_record_id IS NOT NULL)
        ),
    CONSTRAINT person_compliance_record_documents_type_check
        CHECK (content_type IN ('application/pdf', 'image/jpeg', 'image/png')),
    CONSTRAINT person_compliance_record_documents_size_check
        CHECK (file_size BETWEEN 1 AND 10485760),
    CONSTRAINT person_compliance_record_documents_path_check
        CHECK (
            array_length(string_to_array(storage_path, '/'), 1) = 5
            AND (
                (
                    agreement_acknowledgement_id IS NOT NULL
                    AND storage_path LIKE organization_id::TEXT || '/' || person_id::TEXT
                        || '/agreement/' || agreement_acknowledgement_id::TEXT || '/%'
                )
                OR
                (
                    medical_clearance_record_id IS NOT NULL
                    AND storage_path LIKE organization_id::TEXT || '/' || person_id::TEXT
                        || '/medical-clearance/' || medical_clearance_record_id::TEXT || '/%'
                )
            )
        ),
    CONSTRAINT person_compliance_record_documents_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),
    CONSTRAINT person_compliance_record_documents_agreement_fkey
        FOREIGN KEY (organization_id, person_id, agreement_acknowledgement_id)
        REFERENCES public.person_compliance_agreement_acknowledgements
            (organization_id, person_id, id),
    CONSTRAINT person_compliance_record_documents_medical_fkey
        FOREIGN KEY (organization_id, person_id, medical_clearance_record_id)
        REFERENCES public.person_medical_clearance_records
            (organization_id, person_id, id),
    CONSTRAINT person_compliance_record_documents_uploader_fkey
        FOREIGN KEY (organization_id, uploaded_by_person_id)
        REFERENCES public.persons (organization_id, id)
);

CREATE INDEX person_compliance_record_documents_agreement_idx
    ON public.person_compliance_record_documents
        (organization_id, person_id, agreement_acknowledgement_id)
    WHERE agreement_acknowledgement_id IS NOT NULL;
CREATE INDEX person_compliance_record_documents_medical_idx
    ON public.person_compliance_record_documents
        (organization_id, person_id, medical_clearance_record_id)
    WHERE medical_clearance_record_id IS NOT NULL;

ALTER TABLE public.person_compliance_record_documents ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, DELETE
    ON public.person_compliance_record_documents TO authenticated;

CREATE POLICY person_compliance_record_documents_select_policy
ON public.person_compliance_record_documents
FOR SELECT TO authenticated
USING (
    (
        agreement_acknowledgement_id IS NOT NULL
        AND (
            public.has_organization_permission(
                (SELECT pai.person_id FROM public.person_auth_identities pai
                 WHERE pai.auth_user_id = auth.uid()),
                organization_id,
                'compliance.agreements.view'::TEXT
            )
            OR public.has_organization_permission(
                (SELECT pai.person_id FROM public.person_auth_identities pai
                 WHERE pai.auth_user_id = auth.uid()),
                organization_id,
                'compliance.agreements.manage'::TEXT
            )
        )
    )
    OR
    (
        medical_clearance_record_id IS NOT NULL
        AND (
            public.has_organization_permission(
                (SELECT pai.person_id FROM public.person_auth_identities pai
                 WHERE pai.auth_user_id = auth.uid()),
                organization_id,
                'compliance.medical_clearance.view'::TEXT
            )
            OR public.has_organization_permission(
                (SELECT pai.person_id FROM public.person_auth_identities pai
                 WHERE pai.auth_user_id = auth.uid()),
                organization_id,
                'compliance.medical_clearance.manage'::TEXT
            )
        )
    )
);

CREATE POLICY person_compliance_record_documents_insert_policy
ON public.person_compliance_record_documents
FOR INSERT TO authenticated
WITH CHECK (
    (
        agreement_acknowledgement_id IS NOT NULL
        AND public.has_organization_permission(
            (SELECT pai.person_id FROM public.person_auth_identities pai
             WHERE pai.auth_user_id = auth.uid()),
            organization_id,
            'compliance.agreements.manage'::TEXT
        )
    )
    OR
    (
        medical_clearance_record_id IS NOT NULL
        AND public.has_organization_permission(
            (SELECT pai.person_id FROM public.person_auth_identities pai
             WHERE pai.auth_user_id = auth.uid()),
            organization_id,
            'compliance.medical_clearance.manage'::TEXT
        )
    )
);

CREATE POLICY person_compliance_record_documents_delete_policy
ON public.person_compliance_record_documents
FOR DELETE TO authenticated
USING (
    (
        agreement_acknowledgement_id IS NOT NULL
        AND public.has_organization_permission(
            (SELECT pai.person_id FROM public.person_auth_identities pai
             WHERE pai.auth_user_id = auth.uid()),
            organization_id,
            'compliance.agreements.manage'::TEXT
        )
    )
    OR
    (
        medical_clearance_record_id IS NOT NULL
        AND public.has_organization_permission(
            (SELECT pai.person_id FROM public.person_auth_identities pai
             WHERE pai.auth_user_id = auth.uid()),
            organization_id,
            'compliance.medical_clearance.manage'::TEXT
        )
    )
);

-- ---------------------------------------------------------------------------
-- 6. Storage object policies. Paths:
-- organization_id/person_id/agreement/acknowledgement_id/file
-- organization_id/person_id/medical-clearance/record_id/file
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS person_compliance_record_storage_select_policy ON storage.objects;
CREATE POLICY person_compliance_record_storage_select_policy
ON storage.objects
FOR SELECT TO authenticated
USING (
    bucket_id = 'person-compliance-record-documents'
    AND array_length(string_to_array(name, '/'), 1) = 5
    AND EXISTS (
        SELECT 1 FROM public.person_compliance_record_documents d
        WHERE d.storage_path = storage.objects.name
    )
);

DROP POLICY IF EXISTS person_compliance_record_storage_insert_policy ON storage.objects;
CREATE POLICY person_compliance_record_storage_insert_policy
ON storage.objects
FOR INSERT TO authenticated
WITH CHECK (
    bucket_id = 'person-compliance-record-documents'
    AND array_length(string_to_array(name, '/'), 1) = 5
    AND (
        (
            split_part(name, '/', 3) = 'agreement'
            AND EXISTS (
                SELECT 1
                FROM public.person_compliance_agreement_acknowledgements a
                WHERE a.organization_id::TEXT = split_part(name, '/', 1)
                  AND a.person_id::TEXT = split_part(name, '/', 2)
                  AND a.id::TEXT = split_part(name, '/', 4)
                  AND public.has_organization_permission(
                      (SELECT pai.person_id FROM public.person_auth_identities pai
                       WHERE pai.auth_user_id = auth.uid()),
                      a.organization_id,
                      'compliance.agreements.manage'::TEXT
                  )
            )
        )
        OR
        (
            split_part(name, '/', 3) = 'medical-clearance'
            AND EXISTS (
                SELECT 1
                FROM public.person_medical_clearance_records m
                WHERE m.organization_id::TEXT = split_part(name, '/', 1)
                  AND m.person_id::TEXT = split_part(name, '/', 2)
                  AND m.id::TEXT = split_part(name, '/', 4)
                  AND public.has_organization_permission(
                      (SELECT pai.person_id FROM public.person_auth_identities pai
                       WHERE pai.auth_user_id = auth.uid()),
                      m.organization_id,
                      'compliance.medical_clearance.manage'::TEXT
                  )
            )
        )
    )
);

DROP POLICY IF EXISTS person_compliance_record_storage_delete_policy ON storage.objects;
CREATE POLICY person_compliance_record_storage_delete_policy
ON storage.objects
FOR DELETE TO authenticated
USING (
    bucket_id = 'person-compliance-record-documents'
    AND array_length(string_to_array(name, '/'), 1) = 5
    AND (
        (
            split_part(name, '/', 3) = 'agreement'
            AND EXISTS (
                SELECT 1
                FROM public.person_compliance_agreement_acknowledgements a
                WHERE a.organization_id::TEXT = split_part(name, '/', 1)
                  AND a.person_id::TEXT = split_part(name, '/', 2)
                  AND a.id::TEXT = split_part(name, '/', 4)
                  AND public.has_organization_permission(
                      (SELECT pai.person_id FROM public.person_auth_identities pai
                       WHERE pai.auth_user_id = auth.uid()),
                      a.organization_id,
                      'compliance.agreements.manage'::TEXT
                  )
            )
        )
        OR
        (
            split_part(name, '/', 3) = 'medical-clearance'
            AND EXISTS (
                SELECT 1
                FROM public.person_medical_clearance_records m
                WHERE m.organization_id::TEXT = split_part(name, '/', 1)
                  AND m.person_id::TEXT = split_part(name, '/', 2)
                  AND m.id::TEXT = split_part(name, '/', 4)
                  AND public.has_organization_permission(
                      (SELECT pai.person_id FROM public.person_auth_identities pai
                       WHERE pai.auth_user_id = auth.uid()),
                      m.organization_id,
                      'compliance.medical_clearance.manage'::TEXT
                  )
            )
        )
    )
);

-- ---------------------------------------------------------------------------
-- 7. Grant these permissions to existing System Administrators and keep that
--    behavior for future System Administrator assignments.
-- ---------------------------------------------------------------------------
INSERT INTO public.functional_role_permissions (
    organization_id, functional_role_id, permission_id
)
SELECT fr.organization_id, fr.id, p.id
FROM public.functional_roles fr
JOIN public.permissions p
    ON p.key IN (
        'compliance.agreements.view',
        'compliance.agreements.manage',
        'compliance.medical_clearance.view',
        'compliance.medical_clearance.manage'
    )
LEFT JOIN public.functional_role_catalog_roles rcr
    ON rcr.id = fr.catalog_role_id
WHERE fr.status = 'active'
  AND (
      fr.slug = 'system-administrator'
      OR fr.name = 'System Administrator'
      OR rcr.slug = 'system-administrator'
  )
ON CONFLICT (organization_id, functional_role_id, permission_id) DO NOTHING;

CREATE OR REPLACE FUNCTION public.grant_system_admin_compliance_record_permissions()
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
            organization_id, functional_role_id, permission_id
        )
        SELECT NEW.organization_id, NEW.functional_role_id, p.id
        FROM public.permissions p
        WHERE p.key IN (
            'compliance.agreements.view',
            'compliance.agreements.manage',
            'compliance.medical_clearance.view',
            'compliance.medical_clearance.manage'
        )
        ON CONFLICT (organization_id, functional_role_id, permission_id)
        DO NOTHING;
    END IF;

    RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS grant_system_admin_compliance_record_permissions_trigger
    ON public.functional_role_assignments;
CREATE TRIGGER grant_system_admin_compliance_record_permissions_trigger
AFTER INSERT OR UPDATE OF status, functional_role_id
ON public.functional_role_assignments
FOR EACH ROW
EXECUTE FUNCTION public.grant_system_admin_compliance_record_permissions();
