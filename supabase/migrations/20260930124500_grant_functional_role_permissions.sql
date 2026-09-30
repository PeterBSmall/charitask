-- Grant Functional Role permissions to System Administrator
-- for existing organizations and future organization provisioning.

INSERT INTO public.functional_role_permissions (
    organization_id,
    functional_role_id,
    permission_id
)
SELECT
    fr.organization_id,
    fr.id,
    p.id
FROM public.functional_roles fr
JOIN public.permissions p
    ON p.key IN (
        'functionalrole.view',
        'functionalrole.create',
        'functionalrole.edit',
        'functionalrole.delete',
        'functionalrole.manage'
    )
WHERE fr.name = 'System Administrator'
  AND fr.status = 'active'
ON CONFLICT (organization_id, functional_role_id, permission_id)
DO NOTHING;


-- Update organization provisioning so newly created
-- System Administrator roles receive Functional Role permissions.
CREATE OR REPLACE FUNCTION public.provision_initial_organization(
    p_organization_name TEXT,
    p_person_id UUID,
    p_location_name TEXT DEFAULT NULL,
    p_workspace_name TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $function$
DECLARE
    v_organization_id UUID;
    v_person_id UUID;
    v_membership_id UUID;
    v_org_role_id UUID;
    v_functional_role_id UUID;
    v_administration_category_id UUID;
    v_location_id UUID;
    v_workspace_id UUID;
    v_workspace_membership_id UUID;
BEGIN
    IF p_person_id IS NULL THEN
        RAISE EXCEPTION 'Person ID is required';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.persons
        WHERE id = p_person_id
    ) THEN
        RAISE EXCEPTION 'Person does not exist';
    END IF;

    INSERT INTO public.organizations (
        name,
        slug
    )
    VALUES (
        p_organization_name,
        lower(regexp_replace(trim(p_organization_name), '[^a-zA-Z0-9]+', '-', 'g'))
    )
    RETURNING id INTO v_organization_id;

    INSERT INTO public.organization_memberships (
        organization_id,
        person_id,
        status
    )
    VALUES (
        v_organization_id,
        p_person_id,
        'active'
    )
    RETURNING id INTO v_membership_id;

    INSERT INTO public.organizational_roles (
        organization_id,
        name,
        slug,
        description,
        is_system_role,
        status
    )
    VALUES (
        v_organization_id,
        'System Administrator',
        'system-administrator',
        'Full administrative access to the organization.',
        true,
        'active'
    )
    RETURNING id INTO v_org_role_id;

    INSERT INTO public.organizational_role_assignments (
        organization_id,
        person_id,
        organizational_role_id,
        status
    )
    VALUES (
        v_organization_id,
        p_person_id,
        v_org_role_id,
        'active'
    );

    INSERT INTO public.functional_role_categories (
        organization_id,
        name,
        slug,
        description,
        sort_order,
        status
    )
    VALUES (
        v_organization_id,
        'Administration',
        'administration',
        'Administrative and organizational leadership roles.',
        5,
        'active'
    )
    ON CONFLICT (organization_id, slug)
    DO UPDATE SET
        status = 'active'
    RETURNING id INTO v_administration_category_id;

    INSERT INTO public.functional_roles (
        organization_id,
        name,
        slug,
        description,
        category_id,
        status
    )
    VALUES (
        v_organization_id,
        'System Administrator',
        'system-administrator',
        'Full administrative access to the organization.',
        v_administration_category_id,
        'active'
    )
    RETURNING id INTO v_functional_role_id;

    INSERT INTO public.functional_role_assignments (
        organization_id,
        person_id,
        functional_role_id,
        status,
        created_by_person_id,
        updated_by_person_id
    )
    VALUES (
        v_organization_id,
        p_person_id,
        v_functional_role_id,
        'active',
        p_person_id,
        p_person_id
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
        'functionalrole.view',
        'functionalrole.create',
        'functionalrole.edit',
        'functionalrole.delete',
        'functionalrole.manage'
    )
    ON CONFLICT (organization_id, functional_role_id, permission_id)
    DO NOTHING;

    RETURN jsonb_build_object(
        'organization_id', v_organization_id,
        'person_id', p_person_id,
        'membership_id', v_membership_id,
        'organizational_role_id', v_org_role_id,
        'functional_role_id', v_functional_role_id
    );
END;
$function$;
