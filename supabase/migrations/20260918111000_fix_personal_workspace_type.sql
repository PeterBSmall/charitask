-- ChariTask Foundation:
-- Ensure Personal Workspaces are explicitly classified as personal.

CREATE OR REPLACE FUNCTION public.create_personal_workspace(
    p_name TEXT,
    p_description TEXT DEFAULT NULL
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
    v_auth_user_id := auth.uid();

    IF v_auth_user_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required.';
    END IF;

    IF NULLIF(TRIM(p_name), '') IS NULL THEN
        RAISE EXCEPTION 'Workspace name is required.';
    END IF;

    SELECT pai.person_id
    INTO v_person_id
    FROM public.person_auth_identities pai
    WHERE pai.auth_user_id = v_auth_user_id
    LIMIT 1;

    IF v_person_id IS NULL THEN
        RAISE EXCEPTION 'ChariTask person identity not found.';
    END IF;

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

    WHILE EXISTS (
        SELECT 1
        FROM public.workspaces w
        WHERE w.organization_id = v_organization_id
          AND w.slug = v_workspace_slug
    ) LOOP
        v_counter := v_counter + 1;
        v_workspace_slug := v_base_slug || '-' || v_counter;
    END LOOP;

    INSERT INTO public.workspaces (
        organization_id,
        name,
        slug,
        description,
        status,
        workspace_type
    )
    VALUES (
        v_organization_id,
        TRIM(p_name),
        v_workspace_slug,
        NULLIF(TRIM(p_description), ''),
        'active',
        'personal'
    )
    RETURNING id INTO v_workspace_id;

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
        'workspace_id', v_workspace_id,
        'organization_id', v_organization_id,
        'person_id', v_person_id,
        'name', TRIM(p_name),
        'description', NULLIF(TRIM(p_description), ''),
        'slug', v_workspace_slug
    );
END;
$$;
