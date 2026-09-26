-- ChariTask Foundation: Enhance Groups
-- Adds Group classification, polymorphic ownership,
-- membership composition, optional location, and creator tracking.
--
-- Ownership is intentionally represented by:
--   owner_type + owner_id
--
-- Supported owner types:
--   organization
--   program
--   location
--   event
--   project
--
-- Program, Event, and Project tables do not yet exist in the
-- migration history, so owner_id is intentionally polymorphic.
-- The owning service/module is responsible for validating that
-- the referenced owner belongs to the same organization.

ALTER TABLE public.groups
    ADD COLUMN IF NOT EXISTS group_type TEXT,
    ADD COLUMN IF NOT EXISTS owner_type TEXT,
    ADD COLUMN IF NOT EXISTS owner_id UUID,
    ADD COLUMN IF NOT EXISTS membership_composition TEXT[] NOT NULL DEFAULT '{}',
    ADD COLUMN IF NOT EXISTS location_id UUID,
    ADD COLUMN IF NOT EXISTS created_by_person_id UUID;

-- ------------------------------------------------------------
-- Group Type
-- ------------------------------------------------------------

ALTER TABLE public.groups
    DROP CONSTRAINT IF EXISTS groups_group_type_check;

ALTER TABLE public.groups
    ADD CONSTRAINT groups_group_type_check
    CHECK (
        group_type IS NULL
        OR group_type IN (
            'team',
            'committee',
            'cohort',
            'participant_group',
            'leadership_team',
            'staff_group'
        )
    );

-- ------------------------------------------------------------
-- Ownership
-- ------------------------------------------------------------

ALTER TABLE public.groups
    DROP CONSTRAINT IF EXISTS groups_owner_type_check;

ALTER TABLE public.groups
    ADD CONSTRAINT groups_owner_type_check
    CHECK (
        owner_type IS NULL
        OR owner_type IN (
            'organization',
            'program',
            'location',
            'event',
            'project'
        )
    );

-- Every new/complete Group must have an owner.
-- Existing rows are allowed to remain temporarily nullable so
-- this migration can be applied safely before existing groups
-- are backfilled through the application.
--
-- The application will require owner_type + owner_id when creating
-- new groups.

ALTER TABLE public.groups
    DROP CONSTRAINT IF EXISTS groups_owner_pair_check;

ALTER TABLE public.groups
    ADD CONSTRAINT groups_owner_pair_check
    CHECK (
        (owner_type IS NULL AND owner_id IS NULL)
        OR
        (owner_type IS NOT NULL AND owner_id IS NOT NULL)
    );

-- ------------------------------------------------------------
-- Membership Composition
-- ------------------------------------------------------------

ALTER TABLE public.groups
    DROP CONSTRAINT IF EXISTS groups_membership_composition_check;

ALTER TABLE public.groups
    ADD CONSTRAINT groups_membership_composition_check
    CHECK (
        membership_composition <@ ARRAY[
            'volunteers',
            'staff',
            'participants'
        ]::TEXT[]
    );

-- ------------------------------------------------------------
-- Optional Location
-- ------------------------------------------------------------

ALTER TABLE public.groups
    DROP CONSTRAINT IF EXISTS groups_location_id_fkey;

ALTER TABLE public.groups
    ADD CONSTRAINT groups_location_id_fkey
    FOREIGN KEY (location_id)
    REFERENCES public.locations(id);

-- ------------------------------------------------------------
-- Created By
-- ------------------------------------------------------------

ALTER TABLE public.groups
    DROP CONSTRAINT IF EXISTS groups_created_by_person_id_fkey;

ALTER TABLE public.groups
    ADD CONSTRAINT groups_created_by_person_id_fkey
    FOREIGN KEY (created_by_person_id)
    REFERENCES public.persons(id);

-- ------------------------------------------------------------
-- Indexes
-- ------------------------------------------------------------

CREATE INDEX IF NOT EXISTS groups_owner_idx
    ON public.groups (owner_type, owner_id);

CREATE INDEX IF NOT EXISTS groups_type_idx
    ON public.groups (organization_id, group_type);

CREATE INDEX IF NOT EXISTS groups_location_idx
    ON public.groups (organization_id, location_id);

CREATE INDEX IF NOT EXISTS groups_created_by_idx
    ON public.groups (organization_id, created_by_person_id);