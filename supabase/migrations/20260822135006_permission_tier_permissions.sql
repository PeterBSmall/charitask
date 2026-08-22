-- ChariTask Foundation: Permission Tier Permissions
-- Connects organization-owned permission tiers
-- to global atomic system permissions.

CREATE TABLE public.permission_tier_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    permission_tier_id UUID NOT NULL,
    permission_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT permission_tier_permissions_unique
        UNIQUE (
            organization_id,
            permission_tier_id,
            permission_id
        ),

    -- Permission tier must belong to this organization.
    CONSTRAINT permission_tier_permissions_organization_tier_fkey
        FOREIGN KEY (organization_id, permission_tier_id)
        REFERENCES public.permission_tiers (organization_id, id),

    -- Permission is a global system definition.
    CONSTRAINT permission_tier_permissions_permission_id_fkey
        FOREIGN KEY (permission_id)
        REFERENCES public.permissions (id)
        ON DELETE CASCADE
);

CREATE INDEX permission_tier_permissions_tier_id_idx
    ON public.permission_tier_permissions (permission_tier_id);

CREATE INDEX permission_tier_permissions_permission_id_idx
    ON public.permission_tier_permissions (permission_id);