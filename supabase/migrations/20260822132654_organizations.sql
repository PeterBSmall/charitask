-- ChariTask Foundation: Organizations
-- The root tenant table for all organization-owned data.

CREATE TABLE public.organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Supports organization-safe composite foreign keys.
ALTER TABLE public.organizations
    ADD CONSTRAINT organizations_organization_id_id_key
    UNIQUE (id);