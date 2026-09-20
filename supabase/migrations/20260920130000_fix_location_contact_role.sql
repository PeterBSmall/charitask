-- ChariTask Foundation:
-- Corrective migration for the Location Contact Role / Relationship field.

ALTER TABLE public.locations
ADD COLUMN IF NOT EXISTS contact_role TEXT;

COMMENT ON COLUMN public.locations.contact_role IS
    'Optional role or relationship of the primary contact to this location.';