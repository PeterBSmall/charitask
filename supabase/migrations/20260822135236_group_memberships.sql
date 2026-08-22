-- ChariTask Foundation: Group Memberships
-- Establishes the relationship between a person and a group.
-- Groups and people must belong to the same organization.
-- This is a relationship table, so lifecycle uses status/ended_at.

CREATE TABLE public.group_memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    group_id UUID NOT NULL,
    person_id UUID NOT NULL,

    status TEXT NOT NULL DEFAULT 'active',

    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    CONSTRAINT group_memberships_organization_group_person_key
        UNIQUE (organization_id, group_id, person_id),

    -- Group must belong to the same organization.
    CONSTRAINT group_memberships_organization_group_fkey
        FOREIGN KEY (organization_id, group_id)
        REFERENCES public.groups (organization_id, id),

    -- Person must belong to the same organization.
    CONSTRAINT group_memberships_organization_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT group_memberships_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT group_memberships_dates_check
        CHECK (
            ended_at IS NULL
            OR ended_at >= started_at
        )
);

CREATE INDEX group_memberships_group_id_idx
    ON public.group_memberships (group_id);

CREATE INDEX group_memberships_person_id_idx
    ON public.group_memberships (person_id);

CREATE INDEX group_memberships_active_group_idx
    ON public.group_memberships (organization_id, group_id)
    WHERE status = 'active';