-- ChariTask Foundation: Person Locations
-- Associates a person with one or more organization locations.
-- This is a relationship table, so lifecycle uses status/ended_at.

CREATE TABLE public.person_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,
    location_id UUID NOT NULL,

    status TEXT NOT NULL DEFAULT 'active',

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    CONSTRAINT person_locations_organization_person_location_key
        UNIQUE (organization_id, person_id, location_id),

    -- Person must belong to this organization.
    CONSTRAINT person_locations_organization_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),

    -- Location must belong to this organization.
    CONSTRAINT person_locations_organization_location_fkey
        FOREIGN KEY (organization_id, location_id)
        REFERENCES public.locations (organization_id, id),

    CONSTRAINT person_locations_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT person_locations_dates_check
        CHECK (
            ended_at IS NULL
            OR ended_at >= started_at
        )
);

CREATE INDEX person_locations_person_id_idx
    ON public.person_locations (person_id);

CREATE INDEX person_locations_location_id_idx
    ON public.person_locations (location_id);

CREATE INDEX person_locations_active_location_idx
    ON public.person_locations (organization_id, location_id)
    WHERE status = 'active';

-- A person can have only one active primary location per organization.
CREATE UNIQUE INDEX person_locations_one_active_primary_idx
    ON public.person_locations (organization_id, person_id)
    WHERE is_primary = TRUE
      AND status = 'active';