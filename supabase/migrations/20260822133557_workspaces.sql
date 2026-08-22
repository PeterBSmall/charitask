-- ChariTask Foundation: Workspaces
-- A workspace is an organization-owned operational boundary.

CREATE TABLE public.workspaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,

    description TEXT,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    archived_at TIMESTAMPTZ,

    CONSTRAINT workspaces_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    -- Slugs only need to be unique within an organization.
    CONSTRAINT workspaces_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT workspaces_status_check
        CHECK (status IN ('active', 'inactive')),

    -- Required for organization-safe composite foreign keys later.
    CONSTRAINT workspaces_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX workspaces_organization_id_idx
    ON public.workspaces (organization_id);

CREATE INDEX workspaces_active_organization_idx
    ON public.workspaces (organization_id)
    WHERE archived_at IS NULL;