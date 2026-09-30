-- ChariTask Foundation: Backfill System Administrator category
-- Existing System Administrator roles should belong to Administration.

UPDATE public.functional_roles fr
SET category_id = frc.id
FROM public.functional_role_categories frc
WHERE fr.organization_id = frc.organization_id
  AND fr.slug = 'system_administrator'
  AND frc.slug = 'administration'
  AND fr.category_id IS NULL;