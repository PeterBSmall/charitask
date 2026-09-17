-- ChariTask Foundation:
-- Correct existing/default Location Category Tags and provide
-- a safe default Location Type for provisioned primary locations.

-- Primary locations created by organization provisioning default to Office.
ALTER TABLE public.locations
    ALTER COLUMN location_type SET DEFAULT 'Office';

-- Correct the default tag terminology.
UPDATE public.organization_location_category_tags
SET
    name = 'Community Outreach',
    slug = 'community-outreach',
    updated_at = NOW()
WHERE slug = 'community-center';

-- Seed the 13 default tags for organizations that already exist.
INSERT INTO public.organization_location_category_tags (
    organization_id,
    name,
    slug,
    status
)
SELECT
    o.id,
    t.name,
    t.slug,
    'active'
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
) AS t(name, slug)
WHERE NOT EXISTS (
    SELECT 1
    FROM public.organization_location_category_tags existing
    WHERE existing.organization_id = o.id
      AND existing.slug = t.slug
);
