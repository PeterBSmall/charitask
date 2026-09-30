-- ChariTask Foundation: Functional Role Categories
-- Organization-owned categories used to organize Functional Roles.

CREATE TABLE public.functional_role_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,

    description TEXT,

    sort_order INTEGER NOT NULL DEFAULT 0,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    archived_at TIMESTAMPTZ,

    CONSTRAINT functional_role_categories_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    CONSTRAINT functional_role_categories_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT functional_role_categories_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT functional_role_categories_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX functional_role_categories_organization_id_idx
    ON public.functional_role_categories (organization_id);

CREATE INDEX functional_role_categories_active_organization_idx
    ON public.functional_role_categories (
        organization_id,
        sort_order
    )
    WHERE archived_at IS NULL;


-- Add category relationship to Functional Roles.

ALTER TABLE public.functional_roles
    ADD COLUMN category_id UUID;

ALTER TABLE public.functional_roles
    ADD CONSTRAINT functional_roles_organization_category_fkey
        FOREIGN KEY (organization_id, category_id)
        REFERENCES public.functional_role_categories (
            organization_id,
            id
        );

CREATE INDEX functional_roles_category_id_idx
    ON public.functional_roles (category_id);