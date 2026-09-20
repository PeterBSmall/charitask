-- ChariTask Foundation:
-- Fix initial organization provisioning order.
--
-- The person_auth_identities row must exist before the default
-- location category tags are inserted because the tag audit trigger
-- resolves the authenticated person through that identity.

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
AS $function$
DECLARE
    v_auth_user_id UUID;
    v_organization_id UUID;
    v_person_id UUID;
    v_role_id UUID;
    v_functional_role_id UUID;
    v_location_id UUID;
    v_workspace_id UUID;
BEGIN
    v_auth_user_id := auth.uid();

    IF v_auth_user_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required.';
    END IF;

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

    -- 1. Create organization.
    INSERT INTO public.organizations (
        name,
        slug
    )
    VALUES (
        TRIM(p_organization_name),
        TRIM(p_organization_slug)
    )
    RETURNING id INTO v_organization_id;

    -- 2. Create the first Person.
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

    -- 3. Link Person to Supabase Auth BEFORE any audit-triggered inserts.
    INSERT INTO public.person_auth_identities (
        person_id,
        auth_user_id
    )
    VALUES (
        v_person_id,
        v_auth_user_id
    );

    -- 4. Create the organization's default Location Category Tags.
    INSERT INTO public.organization_location_category_tags (
        organization_id,
        name,
        slug,
        status,
        created_by_person_id,
        updated_by_person_id
    )
    VALUES
        (v_organization_id, 'Headquarters', 'headquarters', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Church', 'church', 'active', v_person_id, v_person_id),
        (v_organization_id, 'School', 'school', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Shelter', 'shelter', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Food Bank', 'food-bank', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Clinic', 'clinic', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Training Center', 'training-center', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Distribution Center', 'distribution-center', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Job Site', 'job-site', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Retail Store', 'retail-store', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Administrative', 'administrative', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Volunteer Hub', 'volunteer-hub', 'active', v_person_id, v_person_id),
        (v_organization_id, 'Community Outreach', 'community-outreach', 'active', v_person_id, v_person_id);

    -- 5. Establish organization membership.
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

    -- 6. Create the organizational role.
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

    -- 7. Assign the organizational role.
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

    -- 8. Create System Administrator functional role.
    INSERT INTO public.functional_roles (
        organization_id,
        name,
        slug,
        description,
        status
    )
    VALUES (
        v_organization_id,
        'System Administrator',
        'system_administrator',
        'Full administrative access to the organization.',
        'active'
    )
    RETURNING id INTO v_functional_role_id;

    INSERT INTO public.functional_role_assignments (
        organization_id,
        person_id,
        functional_role_id,
        workspace_id,
        status,
        created_by_person_id,
        updated_by_person_id
    )
    VALUES (
        v_organization_id,
        v_person_id,
        v_functional_role_id,
        NULL,
        'active',
        v_person_id,
        v_person_id
    );

    INSERT INTO public.functional_role_permissions (
        organization_id,
        functional_role_id,
        permission_id
    )
    SELECT
        v_organization_id,
        v_functional_role_id,
        p.id
    FROM public.permissions p
    WHERE p.key IN (
        'people.view',
        'people.create',
        'people.edit',
        'people.delete',
        'locations.view',
        'locations.create',
        'locations.edit',
        'locations.delete'
    )
    ON CONFLICT DO NOTHING;

    -- 9. Create the primary location.
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

    -- 10. Create the initial organization workspace.
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

    -- 11. Add the Person to the initial workspace.
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

    RETURN jsonb_build_object(
        'organization_id', v_organization_id,
        'person_id', v_person_id,
        'organizational_role_id', v_role_id,
        'functional_role_id', v_functional_role_id,
        'location_id', v_location_id,
        'workspace_id', v_workspace_id
    );
END;
$function$;
