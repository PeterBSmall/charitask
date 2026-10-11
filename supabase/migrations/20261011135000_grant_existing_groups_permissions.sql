-- Grant Groups permissions to existing System Administrator roles.

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
JOIN public.permissions p
    ON p.key IN (
        'groups.view',
        'groups.create',
        'groups.edit',
        'groups.delete',
        'groups.manage'
    )
WHERE fr.name = 'System Administrator'
  AND fr.status = 'active'
ON CONFLICT (organization_id, functional_role_id, permission_id)
DO NOTHING;