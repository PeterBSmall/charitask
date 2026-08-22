-- ChariTask Foundation: Organizational Roles
-- Represents what a person is within the organization.
-- Organizational roles are intentionally separate from
-- application authorization roles and permissions.

CREATE TABLE public.organizational_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    archived_at TIMESTAMPTZ,

    CONSTRAINT organizational_roles_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations (id),

    -- Role slugs only need to be unique within an organization.
    CONSTRAINT organizational_roles_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT organizational_roles_status_check
        CHECK (status IN ('active', 'inactive')),

    -- Supports organization-safe composite foreign keys.
    CONSTRAINT organizational_roles_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX organizational_roles_organization_id_idx
    ON public.organizational_roles (organization_id);

CREATE INDEX organizational_roles_active_organization_idx
    ON public.organizational_roles (organization_id)
    WHERE archived_at IS NULL;