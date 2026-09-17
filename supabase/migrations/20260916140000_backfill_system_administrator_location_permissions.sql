-- ChariTask Foundation:
-- Backfill System Administrator Location permissions
--
-- Existing organizations created before the System Administrator
-- Location permission provisioning was introduced may not have the
-- complete permission chain required by the Location RLS policies.
--
-- This migration ensures each existing organization has:
--   1. A System Administrator functional role
--   2. The first active organization member assigned to it
--   3. All Location permissions granted to that role
--
-- This does NOT weaken RLS.

DO $$
DECLARE
    v_organization RECORD;
    v_person_id UUID;
    v_functional_role_id UUID;
BEGIN

FOR v_organization IN
    SELECT id
    FROM public.organizations
LOOP

        -- ------------------------------------------------------------
        -- Find the first active person in the organization.
        -- ------------------------------------------------------------

        SELECT om.person_id
        INTO v_person_id
        FROM public.organization_memberships om
        WHERE om.organization_id = v_organization.id
          AND om.status = 'active'
        ORDER BY om.created_at ASC, om.person_id ASC
        LIMIT 1;

        -- Nothing to provision if the organization has no active member.
        IF v_person_id IS NULL THEN
            CONTINUE;
        END IF;

        -- ------------------------------------------------------------
        -- Find or create the System Administrator functional role.
        -- ------------------------------------------------------------

        SELECT fr.id
        INTO v_functional_role_id
        FROM public.functional_roles fr
        WHERE fr.organization_id = v_organization.id
          AND fr.slug = 'system_administrator'
        LIMIT 1;

        IF v_functional_role_id IS NULL THEN

            INSERT INTO public.functional_roles (
                organization_id,
                name,
                slug,
                description,
                status
            )
            VALUES (
                v_organization.id,
                'System Administrator',
                'system_administrator',
                'Full administrative access to the organization.',
                'active'
            )
            RETURNING id INTO v_functional_role_id;

        END IF;

        -- ------------------------------------------------------------
        -- Ensure the first active person has the organization-wide
        -- System Administrator assignment.
        -- ------------------------------------------------------------

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
            v_organization.id,
            v_person_id,
            v_functional_role_id,
            NULL,
            'active',
            v_person_id,
            v_person_id
        )
        ON CONFLICT DO NOTHING;

        -- ------------------------------------------------------------
        -- Grant Location permissions.
        -- ------------------------------------------------------------

        INSERT INTO public.functional_role_permissions (
            organization_id,
            functional_role_id,
            permission_id
        )
        SELECT
            v_organization.id,
            v_functional_role_id,
            p.id
        FROM public.permissions p
        WHERE p.key IN (
            'locations.view',
            'locations.create',
            'locations.edit',
            'locations.delete'
        )
        ON CONFLICT DO NOTHING;

    END LOOP;

END;
$$;