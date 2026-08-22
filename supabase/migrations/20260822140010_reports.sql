-- ChariTask Foundation: Reports
-- Defines reusable report definitions.
-- Reports are organization-owned and may be used by
-- different ChariTask modules without coupling reporting
-- directly to a specific module implementation.

CREATE TABLE public.reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,

    -- Identifies the module or domain this report belongs to.
    module_key TEXT,

    -- Defines the report's implementation or source.
    report_type TEXT NOT NULL DEFAULT 'custom',

    -- Flexible report configuration.
    configuration JSONB NOT NULL DEFAULT '{}'::jsonb,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    archived_at TIMESTAMPTZ,

    CONSTRAINT reports_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations (id),

    CONSTRAINT reports_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT reports_report_type_check
        CHECK (report_type IN (
            'system',
            'custom',
            'saved'
        )),

    CONSTRAINT reports_status_check
        CHECK (status IN ('active', 'inactive')),

    -- Supports organization-safe composite foreign keys.
    CONSTRAINT reports_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX reports_organization_id_idx
    ON public.reports (organization_id);

CREATE INDEX reports_module_key_idx
    ON public.reports (organization_id, module_key);

CREATE INDEX reports_active_organization_idx
    ON public.reports (organization_id)
    WHERE archived_at IS NULL;