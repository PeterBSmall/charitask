-- ChariTask Foundation: Functional Roles
-- Defines the functions a person can perform within ChariTask.
-- Functional roles are separate from organizational roles/titles.

CREATE TABLE public.functional_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    archived_at TIMESTAMPTZ,

    CONSTRAINT functional_roles_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    CONSTRAINT functional_roles_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT functional_roles_status_check
        CHECK (status IN ('active', 'inactive')),

    -- Supports organization-safe composite foreign keys.
    CONSTRAINT functional_roles_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX functional_roles_organization_id_idx
    ON public.functional_roles (organization_id);

CREATE INDEX functional_roles_active_organization_idx
    ON public.functional_roles (organization_id)
    WHERE archived_at IS NULL;