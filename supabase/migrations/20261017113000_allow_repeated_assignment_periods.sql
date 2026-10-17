-- Allow historical membership periods while preventing duplicate active assignments.
-- Existing assignment records and their dates are preserved.

BEGIN;

ALTER TABLE public.group_memberships
    DROP CONSTRAINT IF EXISTS group_memberships_organization_group_person_key;

CREATE UNIQUE INDEX IF NOT EXISTS group_memberships_one_active_pair_idx
    ON public.group_memberships (organization_id, group_id, person_id)
    WHERE status = 'active';

ALTER TABLE public.person_locations
    DROP CONSTRAINT IF EXISTS person_locations_organization_person_location_key;

CREATE UNIQUE INDEX IF NOT EXISTS person_locations_one_active_pair_idx
    ON public.person_locations (organization_id, person_id, location_id)
    WHERE status = 'active';

COMMIT;
