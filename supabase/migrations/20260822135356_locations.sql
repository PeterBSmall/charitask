-- ChariTask Foundation: Locations
-- Organization-owned physical or operational locations.
-- Examples: offices, ReStores, warehouses, job sites,
-- donation centers, and event locations.

CREATE TABLE public.locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,

    location_type TEXT,

    address_line_1 TEXT,
    address_line_2 TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    country TEXT DEFAULT 'US',

    phone TEXT,
    email TEXT,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    archived_at TIMESTAMPTZ,

    CONSTRAINT locations_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    CONSTRAINT locations_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT locations_status_check
        CHECK (status IN ('active', 'inactive')),

    -- Supports organization-safe composite foreign keys later.
    CONSTRAINT locations_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX locations_organization_id_idx
    ON public.locations (organization_id);

CREATE INDEX locations_type_idx
    ON public.locations (organization_id, location_type);

CREATE INDEX locations_active_organization_idx
    ON public.locations (organization_id)
    WHERE archived_at IS NULL;