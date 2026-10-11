-- ChariTask Foundation: Group Membership Roles
-- Adds the person's role within a specific group.
--
-- This is intentionally separate from Functional Roles.
-- Functional Roles describe organizational responsibilities and
-- permissions; membership_role describes a person's role within
-- one specific group.

ALTER TABLE public.group_memberships
    ADD COLUMN IF NOT EXISTS membership_role TEXT NOT NULL DEFAULT 'member';

ALTER TABLE public.group_memberships
    DROP CONSTRAINT IF EXISTS group_memberships_membership_role_check;

ALTER TABLE public.group_memberships
    ADD CONSTRAINT group_memberships_membership_role_check
    CHECK (
        membership_role IN (
            'leader',
            'co_leader',
            'coordinator',
            'member'
        )
    );

CREATE INDEX IF NOT EXISTS group_memberships_role_idx
    ON public.group_memberships (organization_id, group_id, membership_role);