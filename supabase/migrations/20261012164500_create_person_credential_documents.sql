
-- ChariTask: Private supporting documents for credentials.
-- Background-check credentials intentionally cannot have attachments.

-- ============================================================
-- 1. PRIVATE STORAGE BUCKET
-- ============================================================

INSERT INTO storage.buckets (
    id,
    name,
    public,
    file_size_limit,
    allowed_mime_types
)
VALUES (
    'person-credential-documents',
    'person-credential-documents',
    FALSE,
    10485760,
    ARRAY[
        'application/pdf',
        'image/jpeg',
        'image/png'
    ]::TEXT[]
)
ON CONFLICT (id)
DO UPDATE SET
    public = FALSE,
    file_size_limit = 10485760,
    allowed_mime_types = ARRAY[
        'application/pdf',
        'image/jpeg',
        'image/png'
    ]::TEXT[];


-- ============================================================
-- 2. DOCUMENT METADATA
-- ============================================================

-- This composite key lets documents reference a credential
-- while enforcing both the organization and person relationship.

ALTER TABLE public.person_credentials
    ADD CONSTRAINT person_credentials_organization_person_id_key
    UNIQUE (organization_id, person_id, id);


CREATE TABLE public.person_credential_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,
    credential_id UUID NOT NULL,

    storage_path TEXT NOT NULL UNIQUE,
    file_name TEXT NOT NULL,
    content_type TEXT NOT NULL,
    file_size BIGINT NOT NULL,

    uploaded_by_person_id UUID,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_credential_documents_type_check
        CHECK (
            content_type IN (
                'application/pdf',
                'image/jpeg',
                'image/png'
            )
        ),

    CONSTRAINT person_credential_documents_size_check
        CHECK (file_size BETWEEN 1 AND 10485760),

    CONSTRAINT person_credential_documents_path_check
        CHECK (
            storage_path LIKE
                organization_id::TEXT || '/' ||
                person_id::TEXT || '/' ||
                credential_id::TEXT || '/%'
            AND array_length(
                string_to_array(storage_path, '/'),
                1
            ) = 4
        ),

    CONSTRAINT person_credential_documents_credential_fkey
        FOREIGN KEY (organization_id, person_id, credential_id)
        REFERENCES public.person_credentials (
            organization_id,
            person_id,
            id
        ),

    CONSTRAINT person_credential_documents_uploader_fkey
        FOREIGN KEY (organization_id, uploaded_by_person_id)
        REFERENCES public.persons (organization_id, id)
);

CREATE INDEX person_credential_documents_credential_idx
    ON public.person_credential_documents (
        organization_id,
        person_id,
        credential_id
    );


-- ============================================================
-- 3. METADATA ROW-LEVEL SECURITY
-- ============================================================

ALTER TABLE public.person_credential_documents
    ENABLE ROW LEVEL SECURITY;


-- Viewers and credential managers can see document metadata.
-- Background-check credentials are excluded at the database
-- level as well as in the Flutter UI.

CREATE POLICY person_credential_documents_select_policy
ON public.person_credential_documents
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.person_credentials pc
        WHERE pc.organization_id =
                  person_credential_documents.organization_id
          AND pc.person_id =
                  person_credential_documents.person_id
          AND pc.id =
                  person_credential_documents.credential_id
          AND pc.category <> 'background_check'
    )
    AND (
        has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.view'::TEXT
        )
        OR has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.manage'::TEXT
        )
    )
);


CREATE POLICY person_credential_documents_insert_policy
ON public.person_credential_documents
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.person_credentials pc
        WHERE pc.organization_id =
                  person_credential_documents.organization_id
          AND pc.person_id =
                  person_credential_documents.person_id
          AND pc.id =
                  person_credential_documents.credential_id
          AND pc.category <> 'background_check'
    )
    AND has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
        ),
        organization_id,
        'credentials.manage'::TEXT
    )
);


CREATE POLICY person_credential_documents_delete_policy
ON public.person_credential_documents
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
        'credentials.manage'::TEXT
    )
);


-- ============================================================
-- 4. STORAGE OBJECT POLICIES
-- ============================================================
-- Object path:
-- organization_id/person_id/credential_id/safe_filename
--
-- All objects remain private. Access is governed by the
-- credential and organization permissions.

CREATE POLICY person_credential_storage_select_policy
ON storage.objects
FOR SELECT
TO authenticated
USING (
    bucket_id = 'person-credential-documents'
    AND EXISTS (
        SELECT 1
        FROM public.person_credentials pc
        WHERE pc.organization_id::TEXT = split_part(name, '/', 1)
          AND pc.person_id::TEXT = split_part(name, '/', 2)
          AND pc.id::TEXT = split_part(name, '/', 3)
          AND pc.category <> 'background_check'
          AND (
              has_organization_permission(
                  (
                      SELECT pai.person_id
                      FROM public.person_auth_identities pai
                      WHERE pai.auth_user_id = auth.uid()
                  ),
                  pc.organization_id,
                  'credentials.view'::TEXT
              )
              OR has_organization_permission(
                  (
                      SELECT pai.person_id
                      FROM public.person_auth_identities pai
                      WHERE pai.auth_user_id = auth.uid()
                  ),
                  pc.organization_id,
                  'credentials.manage'::TEXT
              )
          )
    )
);


CREATE POLICY person_credential_storage_insert_policy
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'person-credential-documents'
    AND EXISTS (
        SELECT 1
        FROM public.person_credentials pc
        WHERE pc.organization_id::TEXT = split_part(name, '/', 1)
          AND pc.person_id::TEXT = split_part(name, '/', 2)
          AND pc.id::TEXT = split_part(name, '/', 3)
          AND pc.category <> 'background_check'
          AND has_organization_permission(
              (
                  SELECT pai.person_id
                  FROM public.person_auth_identities pai
                  WHERE pai.auth_user_id = auth.uid()
              ),
              pc.organization_id,
              'credentials.manage'::TEXT
          )
    )
);


CREATE POLICY person_credential_storage_delete_policy
ON storage.objects
FOR DELETE
TO authenticated
USING (
    bucket_id = 'person-credential-documents'
    AND EXISTS (
        SELECT 1
        FROM public.person_credentials pc
        WHERE pc.organization_id::TEXT = split_part(name, '/', 1)
          AND pc.person_id::TEXT = split_part(name, '/', 2)
          AND pc.id::TEXT = split_part(name, '/', 3)
          AND pc.category <> 'background_check'
          AND has_organization_permission(
              (
                  SELECT pai.person_id
                  FROM public.person_auth_identities pai
                  WHERE pai.auth_user_id = auth.uid()
              ),
              pc.organization_id,
              'credentials.manage'::TEXT
          )
    )
);


-- ============================================================
-- 5. ALLOW CREDENTIAL MANAGERS TO READ MANAGED CREDENTIALS
-- ============================================================
-- Necessary for operations that insert a record and return it.
-- Background checks still require their dedicated view/manage
-- permission in addition to this general rule.

DROP POLICY IF EXISTS person_credentials_select_policy
ON public.person_credentials;

CREATE POLICY person_credentials_select_policy
ON public.person_credentials
FOR SELECT
TO authenticated
USING (
    (
        has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.view'::TEXT
        )
        OR has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.manage'::TEXT
        )
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
            'credentials.background_checks.view'::TEXT
        )
        OR has_organization_permission(
            (
                SELECT pai.person_id
                FROM public.person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'credentials.background_checks.manage'::TEXT
        )
    )
);
