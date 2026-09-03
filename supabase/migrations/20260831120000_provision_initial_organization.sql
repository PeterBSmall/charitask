-- ChariTask Foundation:
-- Provision the initial organization, person, role,
-- location, workspace, and memberships as one transaction.

CREATE OR REPLACE FUNCTION public.provision_initial_organization(
    p_organization_name TEXT,
    p_organization_slug TEXT,
    p_first_name TEXT,
    p_last_name TEXT,
    p_email TEXT DEFAULT NULL,
    p_phone TEXT DEFAULT NULL,
    p_organization_role_slug TEXT DEFAULT 'founder',
    p_organization_role_name TEXT DEFAULT 'Founder',
    p_location_name TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_auth_user_id UUID;
    v_organization_id UUID;
    v_person_id UUID;
    v_role_id UUID;
    v_location_id UUID;
    v_workspace_id UUID;
BEGIN
    -- ------------------------------------------------------------
    -- 1. Require an authenticated Supabase user.
    -- ------------------------------------------------------------

    v_auth_user_id := auth.uid();

    IF v_auth_user_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required.';
    END IF;

    -- ------------------------------------------------------------
    -- 2. Validate required onboarding data.
    -- ------------------------------------------------------------

    IF NULLIF(TRIM(p_organization_name), '') IS NULL THEN
        RAISE EXCEPTION 'Organization name is required.';
    END IF;

    IF NULLIF(TRIM(p_first_name), '') IS NULL THEN
        RAISE EXCEPTION 'First name is required.';
    END IF;

    IF NULLIF(TRIM(p_last_name), '') IS NULL THEN
        RAISE EXCEPTION 'Last name is required.';
    END IF;

    IF NULLIF(TRIM(p_organization_role_slug), '') IS NULL THEN
        RAISE EXCEPTION 'Organizational role is required.';
    END IF;

    -- ------------------------------------------------------------
    -- 3. Create the organization.
    -- ------------------------------------------------------------

    INSERT INTO public.organizations (
        name,
        slug
    )
    VALUES (
        TRIM(p_organization_name),
        TRIM(p_organization_slug)
    )
    RETURNING id INTO v_organization_id;

    -- ------------------------------------------------------------
    -- 4. Create the first Person.
    -- ------------------------------------------------------------

    INSERT INTO public.persons (
        organization_id,
        first_name,
        last_name,
        email,
        phone,
        status
    )
    VALUES (
        v_organization_id,
        TRIM(p_first_name),
        TRIM(p_last_name),
        NULLIF(TRIM(p_email), ''),
        NULLIF(TRIM(p_phone), ''),
        'active'
    )
    RETURNING id INTO v_person_id;

    -- ------------------------------------------------------------
    -- 5. Link the Person to Supabase Auth.
    -- ------------------------------------------------------------

    INSERT INTO public.person_auth_identities (
        person_id,
        auth_user_id
    )
    VALUES (
        v_person_id,
        v_auth_user_id
    );

    -- ------------------------------------------------------------
    -- 6. Establish organization membership.
    -- ------------------------------------------------------------

    INSERT INTO public.organization_memberships (
        organization_id,
        person_id,
        status,
        created_by_person_id,
        updated_by_person_id
    )
    VALUES (
        v_organization_id,
        v_person_id,
        'active',
        v_person_id,
        v_person_id
    );

    -- ------------------------------------------------------------
    -- 7. Create the initial organizational role.
    --
    -- This is deliberately NOT a functional permission role.
    -- ------------------------------------------------------------

    INSERT INTO public.organizational_roles (
        organization_id,
        name,
        slug,
        status
    )
    VALUES (
        v_organization_id,
        TRIM(p_organization_role_name),
        TRIM(p_organization_role_slug),
        'active'
    )
    RETURNING id INTO v_role_id;

    -- ------------------------------------------------------------
    -- 8. Assign the organizational role to the Person.
    -- ------------------------------------------------------------

    INSERT INTO public.organizational_role_assignments (
        organization_id,
        person_id,
        organizational_role_id,
        status,
        is_primary,
        created_by_person_id,
        updated_by_person_id
    )
    VALUES (
        v_organization_id,
        v_person_id,
        v_role_id,
        'active',
        TRUE,
        v_person_id,
        v_person_id
    );

    -- ------------------------------------------------------------
    -- 9. Create the primary location.
    -- ------------------------------------------------------------

    IF NULLIF(TRIM(p_location_name), '') IS NOT NULL THEN

        INSERT INTO public.locations (
            organization_id,
            name,
            slug,
            status
        )
        VALUES (
            v_organization_id,
            TRIM(p_location_name),
            'primary-location',
            'active'
        )
        RETURNING id INTO v_location_id;

    END IF;

    -- ------------------------------------------------------------
    -- 10. Create the initial workspace.
    -- ------------------------------------------------------------

    INSERT INTO public.workspaces (
        organization_id,
        name,
        slug,
        description,
        status
    )
    VALUES (
        v_organization_id,
        'Main Workspace',
        'main-workspace',
        'Primary workspace for the organization.',
        'active'
    )
    RETURNING id INTO v_workspace_id;

    -- ------------------------------------------------------------
    -- 11. Add the Person to the initial workspace.
    -- ------------------------------------------------------------

    INSERT INTO public.workspace_memberships (
        organization_id,
        workspace_id,
        person_id,
        status,
        created_by_person_id,
        updated_by_person_id
    )
    VALUES (
        v_organization_id,
        v_workspace_id,
        v_person_id,
        'active',
        v_person_id,
        v_person_id
    );

    -- ------------------------------------------------------------
    -- 12. Return the newly-created foundation IDs.
    -- ------------------------------------------------------------

    RETURN jsonb_build_object(
        'organization_id', v_organization_id,
        'person_id', v_person_id,
        'organizational_role_id', v_role_id,
        'location_id', v_location_id,
        'workspace_id', v_workspace_id
    );
END;
$$;