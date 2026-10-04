-- ============================================================
-- Functional Role Master Catalog
-- ============================================================
-- Global catalog used to seed/configure organization-level
-- functional role categories and roles.
--
-- Organization-specific tables remain:
--   functional_role_categories
--   functional_roles
--
-- This migration creates ONLY the master catalog foundation.
-- ============================================================


-- ============================================================
-- 1. Master Functional Role Catalog Categories
-- ============================================================

CREATE TABLE public.functional_role_catalog_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,

    sort_order INTEGER NOT NULL DEFAULT 0,

    status TEXT NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'archived')),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    archived_at TIMESTAMPTZ,

    CONSTRAINT functional_role_catalog_categories_slug_unique
        UNIQUE (slug)
);


-- ============================================================
-- 2. Master Functional Role Catalog Roles
-- ============================================================

CREATE TABLE public.functional_role_catalog_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    catalog_category_id UUID NOT NULL
        REFERENCES public.functional_role_catalog_categories(id)
        ON DELETE RESTRICT,

    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    description TEXT,

    status TEXT NOT NULL DEFAULT 'active'
        CHECK (status IN ('active', 'archived')),

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    archived_at TIMESTAMPTZ,

    CONSTRAINT functional_role_catalog_roles_category_slug_unique
        UNIQUE (catalog_category_id, slug)
);


-- ============================================================
-- 3. Indexes
-- ============================================================

CREATE INDEX idx_functional_role_catalog_categories_sort_order
    ON public.functional_role_catalog_categories(sort_order);

CREATE INDEX idx_functional_role_catalog_categories_status
    ON public.functional_role_catalog_categories(status);

CREATE INDEX idx_functional_role_catalog_roles_category
    ON public.functional_role_catalog_roles(catalog_category_id);

CREATE INDEX idx_functional_role_catalog_roles_status
    ON public.functional_role_catalog_roles(status);


-- ============================================================
-- 4. Updated-at trigger
-- ============================================================

CREATE OR REPLACE FUNCTION public.update_functional_role_catalog_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER set_functional_role_catalog_categories_updated_at
    BEFORE UPDATE ON public.functional_role_catalog_categories
    FOR EACH ROW
    EXECUTE FUNCTION public.update_functional_role_catalog_updated_at();

CREATE TRIGGER set_functional_role_catalog_roles_updated_at
    BEFORE UPDATE ON public.functional_role_catalog_roles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_functional_role_catalog_updated_at();


-- ============================================================
-- 5. Row Level Security
-- ============================================================

ALTER TABLE public.functional_role_catalog_categories
    ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.functional_role_catalog_roles
    ENABLE ROW LEVEL SECURITY;


-- ============================================================
-- 6. Catalog Read Access
-- ============================================================
-- The master catalog is globally readable by authenticated users.
-- This is necessary because onboarding needs to read the catalog
-- before an organization-specific functional-role catalog exists.
-- ============================================================

CREATE POLICY "Authenticated users can view functional role catalog categories"
    ON public.functional_role_catalog_categories
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY "Authenticated users can view functional role catalog roles"
    ON public.functional_role_catalog_roles
    FOR SELECT
    TO authenticated
    USING (true);


-- ============================================================
-- No INSERT / UPDATE / DELETE policies are intentionally created.
--
-- Master catalog maintenance will be performed through controlled
-- database migrations/admin tooling rather than allowing ordinary
-- authenticated users to modify the global catalog.
-- ============================================================