-- ChariTask Foundation: Groups
-- Organization-owned groups used to organize people.
-- Examples include departments, teams, committees,
-- volunteer groups, or other custom groupings.

CREATE TABLE public.groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    archived_at TIMESTAMPTZ,

    CONSTRAINT groups_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    -- Group slugs only need to be unique within an organization.
    CONSTRAINT groups_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT groups_status_check
        CHECK (status IN ('active', 'inactive')),

    -- Supports organization-safe composite foreign keys.
    CONSTRAINT groups_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX groups_organization_id_idx
    ON public.groups (organization_id);

CREATE INDEX groups_active_organization_idx
    ON public.groups (organization_id)
    WHERE archived_at IS NULL;