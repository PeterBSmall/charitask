-- ============================================================
-- Fix Functional Role Category Display Order
-- ============================================================

UPDATE public.functional_role_categories
SET sort_order = CASE slug
  WHEN 'administration' THEN 1
  WHEN 'leadership' THEN 2
  WHEN 'finance' THEN 3
  WHEN 'fundraising-development' THEN 4
  WHEN 'volunteer-services' THEN 5
  WHEN 'programs-services' THEN 6
  WHEN 'retail-operations' THEN 7
  WHEN 'facilities-operations' THEN 8
  ELSE sort_order
END
WHERE slug IN (
  'administration',
  'leadership',
  'finance',
  'fundraising-development',
  'volunteer-services',
  'programs-services',
  'retail-operations',
  'facilities-operations'
);