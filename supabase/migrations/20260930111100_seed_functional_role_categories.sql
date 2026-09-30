-- ChariTask Foundation:
-- Seed organization-owned Functional Role Categories and
-- integrate them into initial organization provisioning.

-- ============================================================
-- 1. Seed the default categories for existing organizations.
-- ============================================================

INSERT INTO public.functional_role_categories (
    organization_id,
    name,
    slug,
    description,
    sort_order,
    status
)
SELECT
    o.id,
    category.name,
    category.slug,
    category.description,
    category.sort_order,
    'active'
FROM public.organizations o
CROSS JOIN (
    VALUES
        (
            'Retail Operations',
            'retail-operations',
            'Roles responsible for retail operations and store activities.',
            1
        ),
        (
            'Volunteer Services',
            'volunteer-services',
            'Roles responsible for volunteer coordination and engagement.',
            2
        ),
        (
            'Fundraising',
            'fundraising',
            'Roles responsible for fundraising and development activities.',
            3
        ),
        (
            'Programs',
            'programs',
            'Roles responsible for programs and program delivery.',
            4
        ),
        (
            'Administration',
            'administration',
            'Roles responsible for organizational administration and leadership support.',
            5
        ),
        (
            'Finance',
            'finance',
            'Roles responsible for financial operations and oversight.',
            6
        ),
        (
            'Facilities',
            'facilities',
            'Roles responsible for facilities, property, and operational infrastructure.',
            7
        ),
        (
            'Leadership',
            'leadership',
            'Roles responsible for organizational leadership and strategic oversight.',
            8
        )
) AS category(name, slug, description, sort_order)
ON CONFLICT (organization_id, slug) DO NOTHING;


-- ============================================================
-- 2. Update initial organization provisioning.
--
-- Every newly-created organization receives the same
-- organization-owned category catalog.
-- ============================================================

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

    -- 3. Link Person to Supabase Auth BEFORE audit-triggered inserts.
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

    -- 5. Create Functional Role Categories.
    INSERT INTO public.functional_role_categories (
        organization_id,
        name,
        slug,
        description,
        sort_order,
        status
    )
    VALUES
        (
            v_organization_id,
            'Retail Operations',
            'retail-operations',
            'Roles responsible for retail operations and store activities.',
            1,
            'active'
        ),
        (
            v_organization_id,
            'Volunteer Services',
            'volunteer-services',
            'Roles responsible for volunteer coordination and engagement.',
            2,
            'active'
        ),
        (
            v_organization_id,
            'Fundraising',
            'fundraising',
            'Roles responsible for fundraising and development activities.',
            3,
            'active'
        ),
        (
            v_organization_id,
            'Programs',
            'programs',
            'Roles responsible for programs and program delivery.',
            4,
            'active'
        ),
        (
            v_organization_id,
            'Administration',
            'administration',
            'Roles responsible for organizational administration and leadership support.',
            5,
            'active'
        ),
        (
            v_organization_id,
            'Finance',
            'finance',
            'Roles responsible for financial operations and oversight.',
            6,
            'active'
        ),
        (
            v_organization_id,
            'Facilities',
            'facilities',
            'Roles responsible for facilities, property, and operational infrastructure.',
            7,
            'active'
        ),
        (
            v_organization_id,
            'Leadership',
            'leadership',
            'Roles responsible for organizational leadership and strategic oversight.',
            8,
            'active'
        );

    -- 6. Establish organization membership.
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

    -- 7. Create the organizational role.
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

    -- 8. Assign the organizational role.
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

    -- 9. Create System Administrator functional role.
    INSERT INTO public.functional_roles (
        organization_id,
        category_id,
        name,
        slug,
        description,
        status
    )
    SELECT
        v_organization_id,
        frc.id,
        'System Administrator',
        'system_administrator',
        'Full administrative access to the organization.',
        'active'
    FROM public.functional_role_categories frc
    WHERE frc.organization_id = v_organization_id
      AND frc.slug = 'administration'
    RETURNING id INTO v_functional_role_id;

    -- 10. Assign System Administrator to the first Person.
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

    -- 11. Grant the System Administrator's initial permissions.
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

    -- 12. Create the primary location.
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

    -- 13. Create the initial organization workspace.
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

    -- 14. Add the Person to the initial workspace.
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