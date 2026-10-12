-- ChariTask: Row-level security for person_locations

ALTER TABLE public.person_locations
    ENABLE ROW LEVEL SECURITY;

CREATE POLICY person_locations_select_policy
ON public.person_locations
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
        'people.view'::text
    )
);

CREATE POLICY person_locations_insert_policy
ON public.person_locations
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
        'people.edit'::text
    )
);

CREATE POLICY person_locations_update_policy
ON public.person_locations
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
        'people.edit'::text
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
        'people.edit'::text
    )
);

CREATE POLICY person_locations_delete_policy
ON public.person_locations
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
        'people.edit'::text
    )
);
