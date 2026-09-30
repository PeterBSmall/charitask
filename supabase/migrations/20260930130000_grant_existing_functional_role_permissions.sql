-- Grant Functional Role permissions to existing System Administrator roles.

INSERT INTO public.functional_role_permissions (
    organization_id,
    functional_role_id,
    permission_id
)
SELECT
    fr.organization_id,
    fr.id,
    p.id
FROM public.functional_roles fr
CROSS JOIN public.permissions p
WHERE fr.name = 'System Administrator'
  AND fr.status = 'active'
  AND p.key IN (
    'functionalrole.view',
    'functionalrole.create',
    'functionalrole.edit',
    'functionalrole.delete',
    'functionalrole.manage'
  )
ON CONFLICT (organization_id, functional_role_id, permission_id)
DO NOTHING;
