-- ChariTask Foundation:
-- Preserve the existing organization provisioning function and explicitly
-- assign the controlled Location Type for the initial primary location.

DO $$
DECLARE
    v_definition TEXT;
    v_original TEXT;
BEGIN
    SELECT pg_get_functiondef(p.oid)
    INTO v_definition
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'provision_initial_organization'
      AND pg_get_function_identity_arguments(p.oid)
          = 'p_organization_name text, p_organization_slug text, p_first_name text, p_last_name text, p_email text, p_phone text, p_organization_role_slug text, p_organization_role_name text, p_location_name text';

    IF v_definition IS NULL THEN
        RAISE EXCEPTION
            'Could not find the existing provision_initial_organization function.';
    END IF;

    v_original := v_definition;

    v_definition := replace(
        v_definition,
        E'        INSERT INTO public.locations (\n            organization_id,\n            name,\n            slug,\n            status\n        )\n        VALUES (\n            v_organization_id,\n            TRIM(p_location_name),\n            ''primary-location'',\n            ''active''\n        )',
        E'        INSERT INTO public.locations (\n            organization_id,\n            name,\n            slug,\n            location_type,\n            status\n        )\n        VALUES (\n            v_organization_id,\n            TRIM(p_location_name),\n            ''primary-location'',\n            ''Office'',\n            ''active''\n        )'
    );

    IF v_definition = v_original THEN
        RAISE EXCEPTION
            'The expected primary-location INSERT was not found. No function changes were made.';
    END IF;

    EXECUTE v_definition;
END
$$;
