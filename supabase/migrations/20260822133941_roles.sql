-- ChariTask Foundation: Roles
-- Organization-owned roles used by the authorization system.
-- Permissions are assigned separately through the role/permission layer.

CREATE TABLE public.roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    archived_at TIMESTAMPTZ,

    CONSTRAINT roles_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    CONSTRAINT roles_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT roles_status_check
        CHECK (status IN ('active', 'inactive')),

    -- Supports organization-safe composite foreign keys.
    CONSTRAINT roles_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX roles_organization_id_idx
    ON public.roles (organization_id);

CREATE INDEX roles_active_organization_idx
    ON public.roles (organization_id)
    WHERE archived_at IS NULL;