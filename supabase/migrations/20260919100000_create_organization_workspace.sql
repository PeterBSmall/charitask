-- ChariTask Foundation:
-- Create an organization workspace, its membership,
-- and its access record as one transaction.

CREATE OR REPLACE FUNCTION public.create_organization_workspace(
    p_name TEXT,
    p_description TEXT DEFAULT NULL,
    p_template_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_auth_user_id UUID;
    v_person_id UUID;
    v_organization_id UUID;
    v_workspace_id UUID;
    v_workspace_slug TEXT;
    v_base_slug TEXT;
    v_counter INTEGER := 0;
BEGIN
    -- ------------------------------------------------------------
    -- 1. Require an authenticated Supabase user.
    -- ------------------------------------------------------------

    v_auth_user_id := auth.uid();

    IF v_auth_user_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required.';
    END IF;

    -- ------------------------------------------------------------
    -- 2. Validate workspace name.
    -- ------------------------------------------------------------

    IF NULLIF(TRIM(p_name), '') IS NULL THEN
        RAISE EXCEPTION 'Workspace name is required.';
    END IF;

    -- ------------------------------------------------------------
    -- 3. Resolve the ChariTask Person.
    -- ------------------------------------------------------------

    SELECT pai.person_id
    INTO v_person_id
    FROM public.person_auth_identities pai
    WHERE pai.auth_user_id = v_auth_user_id
    LIMIT 1;

    IF v_person_id IS NULL THEN
        RAISE EXCEPTION 'ChariTask person identity not found.';
    END IF;

    -- ------------------------------------------------------------
    -- 4. Resolve the active organization membership.
    -- ------------------------------------------------------------

    SELECT om.organization_id
    INTO v_organization_id
    FROM public.organization_memberships om
    WHERE om.person_id = v_person_id
      AND om.status = 'active'
    ORDER BY om.created_at
    LIMIT 1;

    IF v_organization_id IS NULL THEN
        RAISE EXCEPTION 'Active organization membership not found.';
    END IF;

    -- ------------------------------------------------------------
    -- 5. Generate a base slug from the workspace name.
    -- ------------------------------------------------------------

    v_base_slug := lower(trim(p_name));

    v_base_slug := regexp_replace(
        v_base_slug,
        '[^a-z0-9]+',
        '-',
        'g'
    );

    v_base_slug := regexp_replace(
        v_base_slug,
        '(^-+|-+$)',
        '',
        'g'
    );

    IF v_base_slug = '' THEN
        v_base_slug := 'workspace';
    END IF;

    v_workspace_slug := v_base_slug;

    -- ------------------------------------------------------------
    -- 6. Ensure the slug is unique within the organization.
    -- ------------------------------------------------------------

    WHILE EXISTS (
        SELECT 1
        FROM public.workspaces w
        WHERE w.organization_id = v_organization_id
          AND w.slug = v_workspace_slug
    ) LOOP
        v_counter := v_counter + 1;
        v_workspace_slug := v_base_slug || '-' || v_counter;
    END LOOP;

    -- ------------------------------------------------------------
    -- 7. Create the organization workspace.
    -- ------------------------------------------------------------

    INSERT INTO public.workspaces (
        organization_id,
        name,
        slug,
        description,
        status,
        workspace_type,
        template_id
    )
    VALUES (
        v_organization_id,
        TRIM(p_name),
        v_workspace_slug,
        NULLIF(TRIM(p_description), ''),
        'active',
        'organization',
        NULLIF(TRIM(p_template_id), '')
    )
    RETURNING id INTO v_workspace_id;

    -- ------------------------------------------------------------
    -- 8. Add the Person to the workspace.
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
    -- 9. Grant workspace access to the creator.
    -- ------------------------------------------------------------

    INSERT INTO public.workspace_access (
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
    -- 10. Return the newly created workspace.
    -- ------------------------------------------------------------

    RETURN jsonb_build_object(
        'workspace_id', v_workspace_id,
        'organization_id', v_organization_id,
        'person_id', v_person_id,
        'name', TRIM(p_name),
        'description', NULLIF(TRIM(p_description), ''),
        'slug', v_workspace_slug,
        'workspace_type', 'organization',
        'template_id', NULLIF(TRIM(p_template_id), '')
    );
END;
$$;
