-- ChariTask Foundation: Permissions
-- Defines the atomic capabilities that can be granted through roles.
-- Permissions are organization-independent system definitions.

CREATE TABLE public.permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    key TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    description TEXT,

    module TEXT NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT permissions_key_format_check
        CHECK (key ~ '^[a-z0-9]+(\.[a-z0-9_]+)+$')
);

CREATE INDEX permissions_module_idx
    ON public.permissions (module);