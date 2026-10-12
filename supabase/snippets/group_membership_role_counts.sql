SELECT
    g.organization_id,
    g.id AS group_id,
    g.name AS group_name,
    gm.membership_role,
    gm.status,
    COUNT(*) AS membership_count
FROM public.group_memberships gm
JOIN public.groups g
    ON g.organization_id = gm.organization_id
    AND g.id = gm.group_id
GROUP BY
    g.organization_id,
    g.id,
    g.name,
    gm.membership_role,
    gm.status
ORDER BY
    g.name,
    gm.membership_role,
    gm.status;