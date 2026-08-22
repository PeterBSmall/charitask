-- ChariTask Foundation: Functional Role Permissions
-- Connects organization-owned functional roles to global system permissions.

CREATE TABLE public.functional_role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    functional_role_id UUID NOT NULL,
    permission_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT functional_role_permissions_unique
        UNIQUE (
            organization_id,
            functional_role_id,
            permission_id
        ),

    -- Functional role must belong to this organization.
    CONSTRAINT functional_role_permissions_organization_role_fkey
        FOREIGN KEY (organization_id, functional_role_id)
        REFERENCES public.functional_roles (organization_id, id),

    -- Permission is a global system definition.
    CONSTRAINT functional_role_permissions_permission_id_fkey
        FOREIGN KEY (permission_id)
        REFERENCES public.permissions (id)
        ON DELETE CASCADE
);

CREATE INDEX functional_role_permissions_role_id_idx
    ON public.functional_role_permissions (functional_role_id);

CREATE INDEX functional_role_permissions_permission_id_idx
    ON public.functional_role_permissions (permission_id);