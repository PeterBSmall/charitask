-- ChariTask: Atomic writes for reusable Compliance Requirements.
-- This migration is additive. It does not delete or rewrite legacy requirements.
-- Functions run as the caller and therefore remain subject to table RLS.

CREATE OR REPLACE FUNCTION public.create_compliance_requirement_with_roles(
    p_organization_id UUID,
    p_name TEXT,
    p_requirement_type TEXT,
    p_credential_category TEXT,
    p_description TEXT,
    p_rules JSONB,
    p_source_template_id UUID,
    p_functional_role_ids UUID[]
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

    IF COALESCE(CARDINALITY(v_role_ids), 0) = 0 THEN
        RAISE EXCEPTION 'Assign this requirement to at least one Functional Role.'
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
      FROM UNNEST(v_role_ids) AS selected(role_id);

    RETURN TO_JSONB(v_requirement) || JSONB_BUILD_OBJECT('role_ids', TO_JSONB(v_role_ids));
END;
$function$;

CREATE OR REPLACE FUNCTION public.update_compliance_requirement_with_roles(
    p_organization_id UUID,
    p_compliance_requirement_id UUID,
    p_name TEXT,
    p_requirement_type TEXT,
    p_credential_category TEXT,
    p_description TEXT,
    p_rules JSONB,
    p_source_template_id UUID,
    p_functional_role_ids UUID[]
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

    IF COALESCE(CARDINALITY(v_role_ids), 0) = 0 THEN
        RAISE EXCEPTION 'Assign this requirement to at least one Functional Role.'
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

    INSERT INTO public.functional_role_compliance_requirements (
        organization_id, functional_role_id, compliance_requirement_id, is_required
    )
    SELECT p_organization_id, selected.role_id, v_requirement.id, TRUE
      FROM UNNEST(v_role_ids) AS selected(role_id);

    RETURN TO_JSONB(v_requirement) || JSONB_BUILD_OBJECT('role_ids', TO_JSONB(v_role_ids));
END;
$function$;

REVOKE ALL ON FUNCTION public.create_compliance_requirement_with_roles(
    UUID, TEXT, TEXT, TEXT, TEXT, JSONB, UUID, UUID[]
) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.update_compliance_requirement_with_roles(
    UUID, UUID, TEXT, TEXT, TEXT, TEXT, JSONB, UUID, UUID[]
) FROM PUBLIC;

GRANT EXECUTE ON FUNCTION public.create_compliance_requirement_with_roles(
    UUID, TEXT, TEXT, TEXT, TEXT, JSONB, UUID, UUID[]
) TO authenticated;
GRANT EXECUTE ON FUNCTION public.update_compliance_requirement_with_roles(
    UUID, UUID, TEXT, TEXT, TEXT, TEXT, JSONB, UUID, UUID[]
) TO authenticated;
