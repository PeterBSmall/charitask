create or replace function public.has_permission(
  p_person_id uuid,
  p_permission_key text
)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.functional_role_assignments fra
    join public.functional_role_permissions frp
      on frp.functional_role_id = fra.functional_role_id
    join public.permissions p
      on p.id = frp.permission_id
    where fra.person_id = p_person_id
      and fra.status = 'active'
      and p.key = p_permission_key
  );
$$;