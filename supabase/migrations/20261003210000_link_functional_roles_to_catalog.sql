-- ============================================================
-- Milestone 1D
-- Link Organization Functional Roles to Master Catalog
-- ============================================================

-- ============================================================
-- 1. Link organization functional role categories to the
--    master functional role catalog categories.
-- ============================================================

ALTER TABLE public.functional_role_categories
ADD COLUMN catalog_category_id UUID
REFERENCES public.functional_role_catalog_categories(id)
ON DELETE RESTRICT;


-- ============================================================
-- 2. Link organization functional roles to the
--    master functional role catalog roles.
-- ============================================================

ALTER TABLE public.functional_roles
ADD COLUMN catalog_role_id UUID
REFERENCES public.functional_role_catalog_roles(id)
ON DELETE RESTRICT;


-- ============================================================
-- 3. Add indexes for catalog lookups.
-- ============================================================

CREATE INDEX idx_functional_role_categories_catalog_category_id
ON public.functional_role_categories(catalog_category_id);

CREATE INDEX idx_functional_roles_catalog_role_id
ON public.functional_roles(catalog_role_id);


-- ============================================================
-- 4. Backfill organization categories that match the
--    master catalog by slug.
--
--    Existing custom categories that do not match remain
--    NULL and therefore remain custom categories.
-- ============================================================

UPDATE public.functional_role_categories frc
SET catalog_category_id = crc.id
FROM public.functional_role_catalog_categories crc
WHERE frc.slug = crc.slug
  AND frc.catalog_category_id IS NULL;


-- ============================================================
-- 5. Backfill organization functional roles that match a
--    master catalog role within the linked catalog category.
--
--    Existing custom roles that do not match remain NULL
--    and therefore remain custom roles.
-- ============================================================

UPDATE public.functional_roles fr
SET catalog_role_id = rcr.id
FROM public.functional_role_categories frc,
     public.functional_role_catalog_categories crc,
     public.functional_role_catalog_roles rcr
WHERE fr.category_id = frc.id
  AND frc.catalog_category_id = crc.id
  AND rcr.catalog_category_id = crc.id
  AND rcr.slug = fr.slug
  AND fr.catalog_role_id IS NULL;


-- ============================================================
-- 6. Document the catalog relationships.
-- ============================================================

COMMENT ON COLUMN public.functional_role_categories.catalog_category_id
IS 'Optional link to the master functional role catalog category. NULL indicates a custom organization category.';

COMMENT ON COLUMN public.functional_roles.catalog_role_id
IS 'Optional link to the master functional role catalog role. NULL indicates a custom organization role.';