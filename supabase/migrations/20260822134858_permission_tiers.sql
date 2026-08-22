-- ChariTask Foundation: Permission Tiers
-- Reusable organization-owned bundles of atomic permissions.
-- Tiers do not replace permissions; they group them.

CREATE TABLE public.permission_tiers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    archived_at TIMESTAMPTZ,

    CONSTRAINT permission_tiers_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    -- Tier slugs only need to be unique within an organization.
    CONSTRAINT permission_tiers_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT permission_tiers_status_check
        CHECK (status IN ('active', 'inactive')),

    -- Supports organization-safe composite foreign keys.
    CONSTRAINT permission_tiers_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX permission_tiers_organization_id_idx
    ON public.permission_tiers (organization_id);

CREATE INDEX permission_tiers_active_organization_idx
    ON public.permission_tiers (organization_id)
    WHERE archived_at IS NULL;