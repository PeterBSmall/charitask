-- ChariTask: Person Type + Group targeting for reusable Compliance Requirements.
-- Additive and local-first. Existing role assignments and legacy records are preserved.

CREATE TABLE public.compliance_requirement_person_types (
    organization_id UUID NOT NULL,
    compliance_requirement_id UUID NOT NULL,
    person_type TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT compliance_requirement_person_types_pk
        PRIMARY KEY (organization_id, compliance_requirement_id, person_type),
    CONSTRAINT compliance_requirement_person_types_requirement_fkey
        FOREIGN KEY (organization_id, compliance_requirement_id)
        REFERENCES public.compliance_requirements (organization_id, id)
        ON DELETE CASCADE,
    CONSTRAINT compliance_requirement_person_types_nonblank_check
        CHECK (length(trim(person_type)) > 0)
);

CREATE INDEX compliance_requirement_person_types_lookup_idx
    ON public.compliance_requirement_person_types (organization_id, person_type);

CREATE TABLE public.compliance_requirement_groups (
    organization_id UUID NOT NULL,
    compliance_requirement_id UUID NOT NULL,
    group_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT compliance_requirement_groups_pk
        PRIMARY KEY (organization_id, compliance_requirement_id, group_id),
    CONSTRAINT compliance_requirement_groups_requirement_fkey
        FOREIGN KEY (organization_id, compliance_requirement_id)
        REFERENCES public.compliance_requirements (organization_id, id)
        ON DELETE CASCADE,
    CONSTRAINT compliance_requirement_groups_group_fkey
        FOREIGN KEY (organization_id, group_id)
        REFERENCES public.groups (organization_id, id)
        ON DELETE CASCADE
);

CREATE INDEX compliance_requirement_groups_group_lookup_idx
    ON public.compliance_requirement_groups (organization_id, group_id);

ALTER TABLE public.compliance_requirement_person_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.compliance_requirement_groups ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, DELETE ON public.compliance_requirement_person_types TO authenticated;
GRANT SELECT, INSERT, DELETE ON public.compliance_requirement_groups TO authenticated;

CREATE POLICY compliance_requirement_person_types_select_policy
ON public.compliance_requirement_person_types FOR SELECT TO authenticated
USING (public.has_organization_permission(
    (SELECT pai.person_id FROM public.person_auth_identities pai WHERE pai.auth_user_id = auth.uid()),
    organization_id, 'functionalrole.view'::text));
CREATE POLICY compliance_requirement_person_types_insert_policy
ON public.compliance_requirement_person_types FOR INSERT TO authenticated
WITH CHECK (public.has_organization_permission(
    (SELECT pai.person_id FROM public.person_auth_identities pai WHERE pai.auth_user_id = auth.uid()),
    organization_id, 'functionalrole.edit'::text));
CREATE POLICY compliance_requirement_person_types_delete_policy
ON public.compliance_requirement_person_types FOR DELETE TO authenticated
USING (public.has_organization_permission(
    (SELECT pai.person_id FROM public.person_auth_identities pai WHERE pai.auth_user_id = auth.uid()),
    organization_id, 'functionalrole.edit'::text));

CREATE POLICY compliance_requirement_groups_select_policy
ON public.compliance_requirement_groups FOR SELECT TO authenticated
USING (public.has_organization_permission(
    (SELECT pai.person_id FROM public.person_auth_identities pai WHERE pai.auth_user_id = auth.uid()),
    organization_id, 'functionalrole.view'::text));
CREATE POLICY compliance_requirement_groups_insert_policy
ON public.compliance_requirement_groups FOR INSERT TO authenticated
WITH CHECK (
    public.has_organization_permission(
        (SELECT pai.person_id FROM public.person_auth_identities pai WHERE pai.auth_user_id = auth.uid()),
        organization_id, 'functionalrole.edit'::text
    )
    AND EXISTS (
        SELECT 1
        FROM public.groups g
        WHERE g.organization_id = compliance_requirement_groups.organization_id
          AND g.id = compliance_requirement_groups.group_id
          AND g.status = 'active'
          AND g.archived_at IS NULL
    )
);
CREATE POLICY compliance_requirement_groups_delete_policy
ON public.compliance_requirement_groups FOR DELETE TO authenticated
USING (public.has_organization_permission(
    (SELECT pai.person_id FROM public.person_auth_identities pai WHERE pai.auth_user_id = auth.uid()),
    organization_id, 'functionalrole.edit'::text));

CREATE OR REPLACE FUNCTION public.create_compliance_requirement_with_targets(
    p_organization_id UUID,
    p_name TEXT,
    p_requirement_type TEXT,
    p_credential_category TEXT,
    p_description TEXT,
    p_rules JSONB,
    p_source_template_id UUID,
    p_functional_role_ids UUID[],
    p_person_types TEXT[],
    p_group_ids UUID[]
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $function$
DECLARE
    v_person_id UUID;
    v_name TEXT;
    v_role_ids UUID[];
    v_person_types TEXT[];
    v_group_ids UUID[];
    v_requirement public.compliance_requirements%ROWTYPE;
    v_template public.compliance_requirement_templates%ROWTYPE;
BEGIN
    v_name := NULLIF(BTRIM(p_name), '');
    IF v_name IS NULL THEN
        RAISE EXCEPTION 'Requirement name is required.' USING ERRCODE = '22023';
    END IF;

    SELECT pai.person_id
      INTO v_person_id
      FROM public.person_auth_identities pai
     WHERE pai.auth_user_id = auth.uid()
     LIMIT 1;

    IF v_person_id IS NULL OR NOT public.has_organization_permission(
        v_person_id, p_organization_id, 'functionalrole.edit'::TEXT
    ) THEN
        RAISE EXCEPTION 'You do not have permission to manage Compliance Requirements.'
            USING ERRCODE = '42501';
    END IF;

    IF p_requirement_type NOT IN (
        'certification_license', 'background_check',
        'agreement_acknowledgement', 'training', 'medical_clearance'
    ) THEN
        RAISE EXCEPTION 'Unsupported Compliance Requirement Type: %', p_requirement_type
            USING ERRCODE = '22023';
    END IF;

    IF p_credential_category IS NOT NULL AND p_credential_category NOT IN (
        'certification', 'license', 'training', 'background_check', 'other'
    ) THEN
        RAISE EXCEPTION 'Unsupported credential category: %', p_credential_category
            USING ERRCODE = '22023';
    END IF;

    IF p_requirement_type = 'certification_license'
       AND (p_credential_category IS NULL OR p_credential_category NOT IN ('certification', 'license')) THEN
        RAISE EXCEPTION 'Certification / License requirements must select Certification or License.'
            USING ERRCODE = '22023';
    ELSIF p_requirement_type = 'background_check'
       AND p_credential_category IS DISTINCT FROM 'background_check' THEN
        RAISE EXCEPTION 'Background Check requirements must use the Background Check category.'
            USING ERRCODE = '22023';
    ELSIF p_requirement_type = 'training'
       AND p_credential_category IS DISTINCT FROM 'training' THEN
        RAISE EXCEPTION 'Training requirements must use the Training category.'
            USING ERRCODE = '22023';
    ELSIF p_requirement_type IN ('agreement_acknowledgement', 'medical_clearance')
       AND p_credential_category IS NOT NULL THEN
        RAISE EXCEPTION 'This requirement type does not use a credential category.'
            USING ERRCODE = '22023';
    END IF;

    IF COALESCE(p_rules, '{}'::JSONB) IS NULL
       OR JSONB_TYPEOF(COALESCE(p_rules, '{}'::JSONB)) <> 'object' THEN
        RAISE EXCEPTION 'Compliance rules must be a JSON object.' USING ERRCODE = '22023';
    END IF;

    SELECT ARRAY_AGG(DISTINCT role_input.role_id ORDER BY role_input.role_id)
      INTO v_role_ids
      FROM UNNEST(COALESCE(p_functional_role_ids, ARRAY[]::UUID[])) AS role_input(role_id)
     WHERE role_input.role_id IS NOT NULL;

    SELECT ARRAY_AGG(DISTINCT BTRIM(type_input.person_type) ORDER BY BTRIM(type_input.person_type))
      INTO v_person_types
      FROM UNNEST(COALESCE(p_person_types, ARRAY[]::TEXT[])) AS type_input(person_type)
     WHERE NULLIF(BTRIM(type_input.person_type), '') IS NOT NULL;

    SELECT ARRAY_AGG(DISTINCT group_input.group_id ORDER BY group_input.group_id)
      INTO v_group_ids
      FROM UNNEST(COALESCE(p_group_ids, ARRAY[]::UUID[])) AS group_input(group_id)
     WHERE group_input.group_id IS NOT NULL;

    IF COALESCE(CARDINALITY(v_role_ids), 0)
       + COALESCE(CARDINALITY(v_person_types), 0)
       + COALESCE(CARDINALITY(v_group_ids), 0) = 0 THEN
        RAISE EXCEPTION 'Select at least one Person Type, Functional Role, or Group.'
            USING ERRCODE = '22023';
    END IF;

    IF EXISTS (
        SELECT 1
          FROM UNNEST(v_role_ids) AS requested(role_id)
          LEFT JOIN public.functional_roles fr
            ON fr.organization_id = p_organization_id
           AND fr.id = requested.role_id
         WHERE fr.id IS NULL
    ) THEN
        RAISE EXCEPTION 'Every selected Functional Role must belong to this organization.'
            USING ERRCODE = '22023';
    END IF;

    IF EXISTS (
        SELECT 1
          FROM UNNEST(COALESCE(v_group_ids, ARRAY[]::UUID[])) AS requested(group_id)
          LEFT JOIN public.groups g
            ON g.organization_id = p_organization_id
           AND g.id = requested.group_id
         WHERE g.id IS NULL OR g.status <> 'active' OR g.archived_at IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Every selected Group must be active and belong to this organization.'
            USING ERRCODE = '22023';
    END IF;

    IF p_source_template_id IS NOT NULL THEN
        SELECT *
          INTO v_template
          FROM public.compliance_requirement_templates t
         WHERE t.id = p_source_template_id
           AND t.is_active = TRUE
           AND (t.organization_id IS NULL OR t.organization_id = p_organization_id);

        IF NOT FOUND THEN
            RAISE EXCEPTION 'The selected Compliance Requirement Template is unavailable.'
                USING ERRCODE = '22023';
        END IF;
    END IF;

    INSERT INTO public.compliance_requirements (
        organization_id, name, requirement_type, credential_category,
        description, rules, source_template_id
    ) VALUES (
        p_organization_id, v_name, p_requirement_type, p_credential_category,
        NULLIF(BTRIM(p_description), ''), COALESCE(p_rules, '{}'::JSONB),
        p_source_template_id
    )
    RETURNING * INTO v_requirement;

    INSERT INTO public.functional_role_compliance_requirements (
        organization_id, functional_role_id, compliance_requirement_id, is_required
    )
    SELECT p_organization_id, selected.role_id, v_requirement.id, TRUE
      FROM UNNEST(COALESCE(v_role_ids, ARRAY[]::UUID[])) AS selected(role_id);

    INSERT INTO public.compliance_requirement_person_types (
        organization_id, compliance_requirement_id, person_type
    )
    SELECT p_organization_id, v_requirement.id, selected.person_type
      FROM UNNEST(COALESCE(v_person_types, ARRAY[]::TEXT[])) AS selected(person_type);

    INSERT INTO public.compliance_requirement_groups (
        organization_id, compliance_requirement_id, group_id
    )
    SELECT p_organization_id, v_requirement.id, selected.group_id
      FROM UNNEST(COALESCE(v_group_ids, ARRAY[]::UUID[])) AS selected(group_id);

    RETURN TO_JSONB(v_requirement) || JSONB_BUILD_OBJECT(
        'role_ids', TO_JSONB(COALESCE(v_role_ids, ARRAY[]::UUID[])),
        'person_types', TO_JSONB(COALESCE(v_person_types, ARRAY[]::TEXT[])),
        'group_ids', TO_JSONB(COALESCE(v_group_ids, ARRAY[]::UUID[]))
    );
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_compliance_requirement_with_targets(
    p_organization_id UUID,
    p_compliance_requirement_id UUID,
    p_name TEXT,
    p_requirement_type TEXT,
    p_credential_category TEXT,
    p_description TEXT,
    p_rules JSONB,
    p_source_template_id UUID,
    p_functional_role_ids UUID[],
    p_person_types TEXT[],
    p_group_ids UUID[]
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $function$
DECLARE
    v_person_id UUID;
    v_name TEXT;
    v_role_ids UUID[];
    v_person_types TEXT[];
    v_group_ids UUID[];
    v_requirement public.compliance_requirements%ROWTYPE;
    v_template public.compliance_requirement_templates%ROWTYPE;
BEGIN
    v_name := NULLIF(BTRIM(p_name), '');
    IF v_name IS NULL THEN
        RAISE EXCEPTION 'Requirement name is required.' USING ERRCODE = '22023';
    END IF;

    SELECT pai.person_id
      INTO v_person_id
      FROM public.person_auth_identities pai
     WHERE pai.auth_user_id = auth.uid()
     LIMIT 1;

    IF v_person_id IS NULL OR NOT public.has_organization_permission(
        v_person_id, p_organization_id, 'functionalrole.edit'::TEXT
    ) THEN
        RAISE EXCEPTION 'You do not have permission to manage Compliance Requirements.'
            USING ERRCODE = '42501';
    END IF;

    IF p_requirement_type NOT IN (
        'certification_license', 'background_check',
        'agreement_acknowledgement', 'training', 'medical_clearance'
    ) THEN
        RAISE EXCEPTION 'Unsupported Compliance Requirement Type: %', p_requirement_type
            USING ERRCODE = '22023';
    END IF;

    IF p_credential_category IS NOT NULL AND p_credential_category NOT IN (
        'certification', 'license', 'training', 'background_check', 'other'
    ) THEN
        RAISE EXCEPTION 'Unsupported credential category: %', p_credential_category
            USING ERRCODE = '22023';
    END IF;

    IF p_requirement_type = 'certification_license'
       AND (p_credential_category IS NULL OR p_credential_category NOT IN ('certification', 'license')) THEN
        RAISE EXCEPTION 'Certification / License requirements must select Certification or License.'
            USING ERRCODE = '22023';
    ELSIF p_requirement_type = 'background_check'
       AND p_credential_category IS DISTINCT FROM 'background_check' THEN
        RAISE EXCEPTION 'Background Check requirements must use the Background Check category.'
            USING ERRCODE = '22023';
    ELSIF p_requirement_type = 'training'
       AND p_credential_category IS DISTINCT FROM 'training' THEN
        RAISE EXCEPTION 'Training requirements must use the Training category.'
            USING ERRCODE = '22023';
    ELSIF p_requirement_type IN ('agreement_acknowledgement', 'medical_clearance')
       AND p_credential_category IS NOT NULL THEN
        RAISE EXCEPTION 'This requirement type does not use a credential category.'
            USING ERRCODE = '22023';
    END IF;

    IF JSONB_TYPEOF(COALESCE(p_rules, '{}'::JSONB)) <> 'object' THEN
        RAISE EXCEPTION 'Compliance rules must be a JSON object.' USING ERRCODE = '22023';
    END IF;

    SELECT ARRAY_AGG(DISTINCT role_input.role_id ORDER BY role_input.role_id)
      INTO v_role_ids
      FROM UNNEST(COALESCE(p_functional_role_ids, ARRAY[]::UUID[])) AS role_input(role_id)
     WHERE role_input.role_id IS NOT NULL;

    SELECT ARRAY_AGG(DISTINCT BTRIM(type_input.person_type) ORDER BY BTRIM(type_input.person_type))
      INTO v_person_types
      FROM UNNEST(COALESCE(p_person_types, ARRAY[]::TEXT[])) AS type_input(person_type)
     WHERE NULLIF(BTRIM(type_input.person_type), '') IS NOT NULL;

    SELECT ARRAY_AGG(DISTINCT group_input.group_id ORDER BY group_input.group_id)
      INTO v_group_ids
      FROM UNNEST(COALESCE(p_group_ids, ARRAY[]::UUID[])) AS group_input(group_id)
     WHERE group_input.group_id IS NOT NULL;

    IF COALESCE(CARDINALITY(v_role_ids), 0)
       + COALESCE(CARDINALITY(v_person_types), 0)
       + COALESCE(CARDINALITY(v_group_ids), 0) = 0 THEN
        RAISE EXCEPTION 'Select at least one Person Type, Functional Role, or Group.'
            USING ERRCODE = '22023';
    END IF;

    IF EXISTS (
        SELECT 1
          FROM UNNEST(v_role_ids) AS requested(role_id)
          LEFT JOIN public.functional_roles fr
            ON fr.organization_id = p_organization_id
           AND fr.id = requested.role_id
         WHERE fr.id IS NULL
    ) THEN
        RAISE EXCEPTION 'Every selected Functional Role must belong to this organization.'
            USING ERRCODE = '22023';
    END IF;

    IF EXISTS (
        SELECT 1
          FROM UNNEST(COALESCE(v_group_ids, ARRAY[]::UUID[])) AS requested(group_id)
          LEFT JOIN public.groups g
            ON g.organization_id = p_organization_id
           AND g.id = requested.group_id
         WHERE g.id IS NULL OR g.status <> 'active' OR g.archived_at IS NOT NULL
    ) THEN
        RAISE EXCEPTION 'Every selected Group must be active and belong to this organization.'
            USING ERRCODE = '22023';
    END IF;

    IF p_source_template_id IS NOT NULL THEN
        SELECT *
          INTO v_template
          FROM public.compliance_requirement_templates t
         WHERE t.id = p_source_template_id
           AND t.is_active = TRUE
           AND (t.organization_id IS NULL OR t.organization_id = p_organization_id);

        IF NOT FOUND THEN
            RAISE EXCEPTION 'The selected Compliance Requirement Template is unavailable.'
                USING ERRCODE = '22023';
        END IF;
    END IF;

    UPDATE public.compliance_requirements
       SET name = v_name,
           requirement_type = p_requirement_type,
           credential_category = p_credential_category,
           description = NULLIF(BTRIM(p_description), ''),
           rules = COALESCE(p_rules, '{}'::JSONB),
           source_template_id = p_source_template_id,
           updated_at = NOW()
     WHERE organization_id = p_organization_id
       AND id = p_compliance_requirement_id
    RETURNING * INTO v_requirement;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'The Compliance Requirement was not found or is not accessible.'
            USING ERRCODE = 'P0002';
    END IF;

    DELETE FROM public.functional_role_compliance_requirements
     WHERE organization_id = p_organization_id
       AND compliance_requirement_id = p_compliance_requirement_id;

    DELETE FROM public.compliance_requirement_person_types
     WHERE organization_id = p_organization_id
       AND compliance_requirement_id = p_compliance_requirement_id;

    DELETE FROM public.compliance_requirement_groups
     WHERE organization_id = p_organization_id
       AND compliance_requirement_id = p_compliance_requirement_id;

    INSERT INTO public.functional_role_compliance_requirements (
        organization_id, functional_role_id, compliance_requirement_id, is_required
    )
    SELECT p_organization_id, selected.role_id, v_requirement.id, TRUE
      FROM UNNEST(COALESCE(v_role_ids, ARRAY[]::UUID[])) AS selected(role_id);

    INSERT INTO public.compliance_requirement_person_types (
        organization_id, compliance_requirement_id, person_type
    )
    SELECT p_organization_id, v_requirement.id, selected.person_type
      FROM UNNEST(COALESCE(v_person_types, ARRAY[]::TEXT[])) AS selected(person_type);

    INSERT INTO public.compliance_requirement_groups (
        organization_id, compliance_requirement_id, group_id
    )
    SELECT p_organization_id, v_requirement.id, selected.group_id
      FROM UNNEST(COALESCE(v_group_ids, ARRAY[]::UUID[])) AS selected(group_id);

    RETURN TO_JSONB(v_requirement) || JSONB_BUILD_OBJECT(
        'role_ids', TO_JSONB(COALESCE(v_role_ids, ARRAY[]::UUID[])),
        'person_types', TO_JSONB(COALESCE(v_person_types, ARRAY[]::TEXT[])),
        'group_ids', TO_JSONB(COALESCE(v_group_ids, ARRAY[]::UUID[]))
    );
END;
$function$;

REVOKE ALL ON FUNCTION public.create_compliance_requirement_with_targets(
    UUID, TEXT, TEXT, TEXT, TEXT, JSONB, UUID, UUID[], TEXT[], UUID[]
) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.update_compliance_requirement_with_targets(
    UUID, UUID, TEXT, TEXT, TEXT, TEXT, JSONB, UUID, UUID[], TEXT[], UUID[]
) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.create_compliance_requirement_with_targets(
    UUID, TEXT, TEXT, TEXT, TEXT, JSONB, UUID, UUID[], TEXT[], UUID[]
) TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_compliance_requirement_with_targets(
    UUID, UUID, TEXT, TEXT, TEXT, TEXT, JSONB, UUID, UUID[], TEXT[], UUID[]
) TO authenticated;
