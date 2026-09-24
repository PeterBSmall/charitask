-- ChariTask Foundation:
-- Make Headquarters a controlled Location Type instead of a
-- Location Category Tag.
--
-- Existing locations using the Headquarters tag are migrated
-- to Location Type = Headquarters.
--
-- The old Headquarters tag is then archived.
--
-- New organizations will no longer receive Headquarters as
-- a category tag, and their initial location will be created
-- as Headquarters.

-- ============================================================
-- 1. UPDATE THE CONTROLLED LOCATION TYPE VALUES
-- ============================================================

ALTER TABLE public.locations
    DROP CONSTRAINT IF EXISTS locations_location_type_check;

ALTER TABLE public.locations
    ADD CONSTRAINT locations_location_type_check
    CHECK (
        location_type IN (
            'Headquarters',
            'Office',
            'Program Site',
            'Community Site',
            'Event Venue',
            'Retail',
            'Warehouse',
            'Service Area',
            'Virtual',
            'Other'
        )
    );


-- ============================================================
-- 2. CONVERT EXISTING HEADQUARTERS TAG ASSIGNMENTS
--    INTO THE HEADQUARTERS LOCATION TYPE
-- ============================================================

UPDATE public.locations AS l
SET location_type = 'Headquarters'
FROM public.location_category_tag_assignments AS a
JOIN public.organization_location_category_tags AS t
    ON t.organization_id = a.organization_id
   AND t.id = a.tag_id
WHERE a.organization_id = l.organization_id
  AND a.location_id = l.id
  AND t.slug = 'headquarters';


-- ============================================================
-- 3. REMOVE THE OLD HEADQUARTERS TAG ASSIGNMENTS
-- ============================================================

DELETE FROM public.location_category_tag_assignments AS a
USING public.organization_location_category_tags AS t
WHERE t.organization_id = a.organization_id
  AND t.id = a.tag_id
  AND t.slug = 'headquarters';


-- ============================================================
-- 4. ARCHIVE THE OLD HEADQUARTERS CATEGORY TAG
-- ============================================================

UPDATE public.organization_location_category_tags
SET
    status = 'inactive',
    archived_at = COALESCE(archived_at, NOW()),
    updated_at = NOW()
WHERE slug = 'headquarters';


-- ============================================================
-- 5. UPDATE ORGANIZATION PROVISIONING
--
-- Remove Headquarters from the default category tags and
-- create the initial organization location as Headquarters.
-- ============================================================

DO $$
DECLARE
    v_definition TEXT;
    v_updated_definition TEXT;
BEGIN
    SELECT pg_get_functiondef(
        'public.provision_initial_organization(
            text,
            text,
            text,
            text,
            text,
            text,
            text,
            text,
            text
        )'::regprocedure
    )
    INTO v_definition;

    -- Remove the Headquarters default category tag.
    v_updated_definition := regexp_replace(
        v_definition,
        E'\\s*\\(\\s*v_organization_id\\s*,\\s*''Headquarters''\\s*,\\s*''headquarters''\\s*,\\s*''active''\\s*,\\s*v_person_id\\s*,\\s*v_person_id\\s*\\)\\s*,',
        '',
        'n'
    );

    -- Make the provisioned primary location a Headquarters.
    v_updated_definition := regexp_replace(
        v_updated_definition,
        E'(TRIM\\(p_location_name\\),\\s*''primary-location'',\\s*''Office''\\s*,)',
        E'\\1',
        'n'
    );

    v_updated_definition := replace(
        v_updated_definition,
        E'''primary-location'',\n            ''Office'',',
        E'''primary-location'',\n            ''Headquarters'','
    );

    IF v_updated_definition = v_definition THEN
        RAISE EXCEPTION
            'Unable to update provision_initial_organization: expected Headquarters/Office provisioning patterns were not found.';
    END IF;

    EXECUTE v_updated_definition;
END
$$;