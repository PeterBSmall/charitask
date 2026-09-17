-- ChariTask: Location audit fields
--
-- Audit fields are automatically populated from the authenticated
-- ChariTask person. Existing locations may have NULL audit values
-- because they predate this audit system.

ALTER TABLE public.locations
    ADD COLUMN IF NOT EXISTS created_by_person_id UUID,
    ADD COLUMN IF NOT EXISTS updated_by_person_id UUID;

-- Ensure the audit person belongs to the same organization
-- as the location.

ALTER TABLE public.locations
    ADD CONSTRAINT locations_created_by_person_fkey
    FOREIGN KEY (organization_id, created_by_person_id)
    REFERENCES public.persons (organization_id, id);

ALTER TABLE public.locations
    ADD CONSTRAINT locations_updated_by_person_fkey
    FOREIGN KEY (organization_id, updated_by_person_id)
    REFERENCES public.persons (organization_id, id);

CREATE INDEX IF NOT EXISTS locations_created_by_person_idx
    ON public.locations (created_by_person_id);

CREATE INDEX IF NOT EXISTS locations_updated_by_person_idx
    ON public.locations (updated_by_person_id);