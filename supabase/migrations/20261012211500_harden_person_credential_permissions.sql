-- ChariTask: Enforce credential-specific permissions on writes.
-- Background checks require their separate management permission.

DROP POLICY IF EXISTS person_credentials_insert_policy
ON public.person_credentials;

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
        'credentials.manage'::TEXT
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
            'credentials.background_checks.manage'::TEXT
        )
    )
);


DROP POLICY IF EXISTS person_credentials_update_policy
ON public.person_credentials;

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
        'credentials.manage'::TEXT
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
            'credentials.background_checks.manage'::TEXT
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
        'credentials.manage'::TEXT
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
            'credentials.background_checks.manage'::TEXT
        )
    )
);


DROP POLICY IF EXISTS person_credentials_delete_policy
ON public.person_credentials;

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
        'credentials.manage'::TEXT
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
            'credentials.background_checks.manage'::TEXT
        )
    )
);