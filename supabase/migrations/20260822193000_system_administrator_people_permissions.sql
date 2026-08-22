-- Assign all People permissions to the System Administrator role.

INSERT INTO public.functional_role_permissions (
  organization_id,
  functional_role_id,
  permission_id
)
SELECT
  '6577ad2b-7142-46d0-9d1f-5366b06e12d5',
  '8e7b976d-fc16-435c-b4f1-30c1f6ac81aa',
  id
FROM public.permissions
WHERE key IN (
  'people.view',
  'people.create',
  'people.edit',
  'people.delete'
)
ON CONFLICT DO NOTHING;