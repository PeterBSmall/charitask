-- ============================================================
-- Milestone 1E
-- Provision Organizations from the Master Functional Role Catalog
-- ============================================================

CREATE OR REPLACE FUNCTION public.provision_initial_organization(
    p_organization_name text,
    p_organization_slug text,
    p_first_name text,
    p_last_name text,
    p_email text DEFAULT NULL::text,
    p_phone text DEFAULT NULL::text,
    p_organization_role_slug text DEFAULT 'founder'::text,
    p_organization_role_name text DEFAULT 'Founder'::text,
    p_location_name text DEFAULT NULL::text
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
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


    -- ========================================================
    -- 1. Create organization.
    -- ========================================================

    INSERT INTO public.organizations (
        name,
        slug
    )
    VALUES (
        TRIM(p_organization_name),
        TRIM(p_organization_slug)
    )
    RETURNING id INTO v_organization_id;


    -- ========================================================
    -- 2. Create the first Person.
    -- ========================================================

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


    -- ========================================================
    -- 3. Link Person to Supabase Auth BEFORE audit-triggered
    --    inserts.
    -- ========================================================

    INSERT INTO public.person_auth_identities (
        person_id,
        auth_user_id
    )
    VALUES (
        v_person_id,
        v_auth_user_id
    );


    -- ========================================================
    -- 4. Create the organization's default Location Category
    --    Tags.
    -- ========================================================

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


    -- ========================================================
    -- 5. Seed ALL active master functional role categories
    --    into the organization.
    --
    --    The master catalog is now the authoritative source
    --    for initial organization functional-role categories.
    -- ========================================================

    INSERT INTO public.functional_role_categories (
        organization_id,
        name,
        slug,
        description,
        sort_order,
        status,
        catalog_category_id
    )
    SELECT
        v_organization_id,
        crc.name,
        crc.slug,
        crc.description,
        crc.sort_order,
        crc.status,
        crc.id
    FROM public.functional_role_catalog_categories crc
    WHERE crc.status = 'active'
    ORDER BY crc.sort_order, crc.name;


    -- ========================================================
    -- 6. Seed ALL active master functional roles into the
    --    organization.
    --
    --    Each role is linked to both:
    --      - the organization's category
    --      - the master catalog role
    -- ========================================================

    INSERT INTO public.functional_roles (
        organization_id,
        category_id,
        name,
        slug,
        description,
        status,
        catalog_role_id
    )
    SELECT
        v_organization_id,
        frc.id,
        rcr.name,
        rcr.slug,
        rcr.description,
        rcr.status,
        rcr.id
    FROM public.functional_role_catalog_roles rcr
    INNER JOIN public.functional_role_categories frc
        ON frc.organization_id = v_organization_id
       AND frc.catalog_category_id = rcr.catalog_category_id
    WHERE rcr.status = 'active'
    ORDER BY frc.sort_order, rcr.name;


    -- ========================================================
    -- 7. Establish organization membership.
    -- ========================================================

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


    -- ========================================================
    -- 8. Create the organizational role.
    --
    --    Organizational Role remains completely separate from
    --    Functional Role.
    -- ========================================================

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


    -- ========================================================
    -- 9. Assign the organizational role.
    -- ========================================================

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


    -- ========================================================
    -- 10. Find the catalog-backed System Administrator role.
    --
    --     System Administrator is no longer a separately
    --     hard-coded organization role. It is provisioned from
    --     the master catalog like every other functional role.
    -- ========================================================

    SELECT fr.id
    INTO v_functional_role_id
    FROM public.functional_roles fr
    INNER JOIN public.functional_role_catalog_roles rcr
        ON rcr.id = fr.catalog_role_id
    WHERE fr.organization_id = v_organization_id
      AND rcr.slug = 'system-administrator'
      AND rcr.status = 'active'
    LIMIT 1;


    IF v_functional_role_id IS NULL THEN
        RAISE EXCEPTION
            'System Administrator functional role was not provisioned for organization %.',
            v_organization_id;
    END IF;


    -- ========================================================
    -- 11. Assign System Administrator to the first Person.
    -- ========================================================

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


    -- ========================================================
    -- 12. Grant the System Administrator's initial permissions.
    -- ========================================================

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
        'locations.delete',
        'functionalrole.view',
        'functionalrole.create',
        'functionalrole.edit',
        'functionalrole.delete',
        'functionalrole.manage'
    )
    ON CONFLICT DO NOTHING;


    -- ========================================================
    -- 13. Create the primary location.
    -- ========================================================

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


    -- ========================================================
    -- 14. Create the initial organization workspace.
    -- ========================================================

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


    -- ========================================================
    -- 15. Add the Person to the initial workspace.
    -- ========================================================

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


    -- ========================================================
    -- 16. Return provisioning result.
    -- ========================================================

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