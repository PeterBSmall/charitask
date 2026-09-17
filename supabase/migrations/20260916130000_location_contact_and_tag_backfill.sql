-- ChariTask Foundation:
-- Location contact information + default tag backfill.
--
-- Contact name is optional and represents the primary contact for a
-- location. It may be an external contact and does not have to be
-- a ChariTask Person.

ALTER TABLE public.locations
ADD COLUMN IF NOT EXISTS contact_name TEXT;

COMMENT ON COLUMN public.locations.contact_name IS
    'Optional primary contact name for this location.';


-- ============================================================
-- BACKFILL DEFAULT LOCATION CATEGORY TAGS
-- ============================================================
--
-- New organizations receive these during provisioning.
-- This section ensures organizations created before that
-- provisioning change also receive the defaults.
--
-- Tags remain organization-owned and can be edited/archived later.

INSERT INTO public.organization_location_category_tags (
    organization_id,
    name,
    slug,
    status,
    created_by_person_id,
    updated_by_person_id
)
SELECT
    o.id,
    defaults.name,
    defaults.slug,
    'active',
    creator.person_id,
    creator.person_id
FROM public.organizations o
CROSS JOIN (
    VALUES
        ('Headquarters', 'headquarters'),
        ('Church', 'church'),
        ('School', 'school'),
        ('Shelter', 'shelter'),
        ('Food Bank', 'food-bank'),
        ('Clinic', 'clinic'),
        ('Training Center', 'training-center'),
        ('Distribution Center', 'distribution-center'),
        ('Job Site', 'job-site'),
        ('Retail Store', 'retail-store'),
        ('Administrative', 'administrative'),
        ('Volunteer Hub', 'volunteer-hub'),
        ('Community Outreach', 'community-outreach')
) AS defaults(name, slug)
LEFT JOIN LATERAL (
    SELECT p.id AS person_id
    FROM public.persons p
    JOIN public.organization_memberships om
        ON om.organization_id = p.organization_id
       AND om.person_id = p.id
    WHERE p.organization_id = o.id
      AND om.status = 'active'
    ORDER BY om.started_at, p.created_at
    LIMIT 1
) AS creator
    ON TRUE
WHERE creator.person_id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM public.organization_location_category_tags existing
      WHERE existing.organization_id = o.id
        AND existing.slug = defaults.slug
  );


-- ============================================================
-- LOCATION AUDIT FIELDS
-- ============================================================
--
-- Ensure location audit ownership is populated automatically
-- from the authenticated ChariTask Person.

CREATE OR REPLACE FUNCTION public.set_location_audit_fields()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_person_id UUID;
BEGIN
    SELECT pai.person_id
    INTO v_person_id
    FROM public.person_auth_identities pai
    WHERE pai.auth_user_id = auth.uid()
    LIMIT 1;

    IF TG_OP = 'INSERT' THEN
        IF NEW.created_by_person_id IS NULL THEN
            NEW.created_by_person_id := v_person_id;
        END IF;

        IF NEW.updated_by_person_id IS NULL THEN
            NEW.updated_by_person_id := v_person_id;
        END IF;

    ELSIF TG_OP = 'UPDATE' THEN
        NEW.updated_by_person_id := COALESCE(
            v_person_id,
            NEW.updated_by_person_id
        );
        NEW.updated_at := NOW();
    END IF;

    RETURN NEW;
END;
$$;


DROP TRIGGER IF EXISTS locations_set_audit_fields
ON public.locations;

CREATE TRIGGER locations_set_audit_fields
BEFORE INSERT OR UPDATE
ON public.locations
FOR EACH ROW
EXECUTE FUNCTION public.set_location_audit_fields();