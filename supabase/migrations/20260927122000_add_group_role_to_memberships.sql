-- ChariTask Group Membership Roles
-- A person's role is a property of their membership in a group.

ALTER TABLE public.group_memberships
ADD COLUMN group_role TEXT NOT NULL DEFAULT 'member';

ALTER TABLE public.group_memberships
ADD CONSTRAINT group_memberships_group_role_check
CHECK (
    group_role IN (
        'leader',
        'co_leader',
        'coordinator',
        'member'
    )
);