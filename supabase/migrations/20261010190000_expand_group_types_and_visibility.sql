-- ChariTask Foundation: Expand Groups
-- Adds additional group classifications and visibility.

ALTER TABLE public.groups
    ADD COLUMN IF NOT EXISTS visibility TEXT NOT NULL DEFAULT 'private';

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
            'department',
            'cohort',
            'participant_group',
            'leadership_team',
            'staff_group',
            'volunteer_group',
            'board',
            'donor_circle',
            'ministry'
        )
    );

-- ------------------------------------------------------------
-- Visibility
-- ------------------------------------------------------------

ALTER TABLE public.groups
    DROP CONSTRAINT IF EXISTS groups_visibility_check;

ALTER TABLE public.groups
    ADD CONSTRAINT groups_visibility_check
    CHECK (
        visibility IN (
            'public',
            'private',
            'hidden'
        )
    );

CREATE INDEX IF NOT EXISTS groups_visibility_idx
    ON public.groups (organization_id, visibility);