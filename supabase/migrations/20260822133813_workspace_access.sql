-- ChariTask Foundation: Workspace Access
-- Separates workspace membership from authorization to access the workspace.
-- This is a relationship record, so lifecycle uses status/ended_at.

CREATE TABLE public.workspace_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    workspace_id UUID NOT NULL,
    person_id UUID NOT NULL,

    status TEXT NOT NULL DEFAULT 'active',

    granted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    CONSTRAINT workspace_access_organization_workspace_person_key
        UNIQUE (organization_id, workspace_id, person_id),

    -- Workspace must belong to the same organization.
    CONSTRAINT workspace_access_organization_workspace_fkey
        FOREIGN KEY (organization_id, workspace_id)
        REFERENCES public.workspaces (organization_id, id),

    -- Person must belong to the same organization.
    CONSTRAINT workspace_access_organization_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT workspace_access_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT workspace_access_dates_check
        CHECK (
            ended_at IS NULL
            OR ended_at >= granted_at
        )
);

CREATE INDEX workspace_access_workspace_id_idx
    ON public.workspace_access (workspace_id);

CREATE INDEX workspace_access_person_id_idx
    ON public.workspace_access (person_id);

CREATE INDEX workspace_access_active_workspace_idx
    ON public.workspace_access (organization_id, workspace_id)
    WHERE status = 'active';