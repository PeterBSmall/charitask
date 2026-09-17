-- ChariTask Foundation:
-- Add management, capacity, geographic, and internal-note fields
-- to organization-owned locations.

ALTER TABLE public.locations
    ADD COLUMN location_manager_person_id UUID,
    ADD COLUMN primary_contact_person_id UUID,
    ADD COLUMN building_capacity INTEGER,
    ADD COLUMN parking_spaces INTEGER,
    ADD COLUMN volunteer_capacity INTEGER,
    ADD COLUMN latitude NUMERIC(9,6),
    ADD COLUMN longitude NUMERIC(9,6),
    ADD COLUMN timezone TEXT,
    ADD COLUMN internal_notes TEXT;

ALTER TABLE public.locations
    ADD CONSTRAINT locations_location_manager_person_fk
        FOREIGN KEY (location_manager_person_id)
        REFERENCES public.persons(id)
        ON DELETE SET NULL;

ALTER TABLE public.locations
    ADD CONSTRAINT locations_primary_contact_person_fk
        FOREIGN KEY (primary_contact_person_id)
        REFERENCES public.persons(id)
        ON DELETE SET NULL;

ALTER TABLE public.locations
    ADD CONSTRAINT locations_building_capacity_check
        CHECK (building_capacity IS NULL OR building_capacity >= 0);

ALTER TABLE public.locations
    ADD CONSTRAINT locations_parking_spaces_check
        CHECK (parking_spaces IS NULL OR parking_spaces >= 0);

ALTER TABLE public.locations
    ADD CONSTRAINT locations_volunteer_capacity_check
        CHECK (volunteer_capacity IS NULL OR volunteer_capacity >= 0);

ALTER TABLE public.locations
    ADD CONSTRAINT locations_latitude_check
        CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90);

ALTER TABLE public.locations
    ADD CONSTRAINT locations_longitude_check
        CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180);
