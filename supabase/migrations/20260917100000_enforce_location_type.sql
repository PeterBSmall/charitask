-- ChariTask Foundation:
-- Enforce controlled Location Type values.
--
-- Location Type is a single primary system-controlled value.
-- Category Tags remain organization-owned and configurable.

ALTER TABLE public.locations
    ALTER COLUMN location_type SET NOT NULL;

ALTER TABLE public.locations
    ADD CONSTRAINT locations_location_type_check
    CHECK (
        location_type IN (
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
