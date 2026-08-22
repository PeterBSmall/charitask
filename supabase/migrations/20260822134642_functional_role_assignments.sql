-- ChariTask Foundation: Functional Role Assignments
-- Assigns functional capabilities to a person.
-- Functional roles are separate from organizational roles.
-- Assignments may optionally be scoped to a workspace.

CREATE TABLE public.functional_role_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,
    functional_role_id UUID NOT NULL,

    workspace_id UUID,

    status TEXT NOT NULL DEFAULT 'active',

    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    -- Prevent duplicate assignments within the same scope.
    CONSTRAINT functional_role_assignments_scope_key
        UNIQUE NULLS NOT DISTINCT (
            organization_id,
            person_id,
            functional_role_id,
            workspace_id
        ),

    -- Person must belong to this organization.
    CONSTRAINT functional_role_assignments_organization_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),

    -- Functional role must belong to this organization.
    CONSTRAINT functional_role_assignments_organization_role_fkey
        FOREIGN KEY (organization_id, functional_role_id)
        REFERENCES public.functional_roles (organization_id, id),

    -- If workspace-scoped, the workspace must belong to this organization.
    CONSTRAINT functional_role_assignments_organization_workspace_fkey
        FOREIGN KEY (organization_id, workspace_id)
        REFERENCES public.workspaces (organization_id, id),

    CONSTRAINT functional_role_assignments_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT functional_role_assignments_dates_check
        CHECK (
            ended_at IS NULL
            OR ended_at >= assigned_at
        )
);

CREATE INDEX functional_role_assignments_person_id_idx
    ON public.functional_role_assignments (person_id);

CREATE INDEX functional_role_assignments_role_id_idx
    ON public.functional_role_assignments (functional_role_id);

CREATE INDEX functional_role_assignments_workspace_id_idx
    ON public.functional_role_assignments (workspace_id)
    WHERE workspace_id IS NOT NULL;

CREATE INDEX functional_role_assignments_active_person_idx
    ON public.functional_role_assignments (
        organization_id,
        person_id
    )
    WHERE status = 'active';