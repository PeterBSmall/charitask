-- ChariTask Foundation: Role Permissions
-- Connects organization-owned roles to global system permissions.

CREATE TABLE public.role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    role_id UUID NOT NULL,
    permission_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT role_permissions_organization_role_permission_key
        UNIQUE (
            organization_id,
            role_id,
            permission_id
        ),

    -- Role must belong to this organization.
    CONSTRAINT role_permissions_organization_role_fkey
        FOREIGN KEY (organization_id, role_id)
        REFERENCES public.roles (organization_id, id),

    CONSTRAINT role_permissions_permission_id_fkey
        FOREIGN KEY (permission_id)
        REFERENCES public.permissions (id)
        ON DELETE CASCADE
);

CREATE INDEX role_permissions_role_id_idx
    ON public.role_permissions (role_id);

CREATE INDEX role_permissions_permission_id_idx
    ON public.role_permissions (permission_id);