-- ChariTask Foundation: Workspace Locations
-- Associates a workspace with one or more organization locations.
-- This is a relationship table, so lifecycle uses status/ended_at.

CREATE TABLE public.workspace_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    workspace_id UUID NOT NULL,
    location_id UUID NOT NULL,

    status TEXT NOT NULL DEFAULT 'active',

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    CONSTRAINT workspace_locations_organization_workspace_location_key
        UNIQUE (organization_id, workspace_id, location_id),

    -- Workspace must belong to this organization.
    CONSTRAINT workspace_locations_organization_workspace_fkey
        FOREIGN KEY (organization_id, workspace_id)
        REFERENCES public.workspaces (organization_id, id),

    -- Location must belong to this organization.
    CONSTRAINT workspace_locations_organization_location_fkey
        FOREIGN KEY (organization_id, location_id)
        REFERENCES public.locations (organization_id, id),

    CONSTRAINT workspace_locations_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT workspace_locations_dates_check
        CHECK (
            ended_at IS NULL
            OR ended_at >= started_at
        )
);

CREATE INDEX workspace_locations_workspace_id_idx
    ON public.workspace_locations (workspace_id);

CREATE INDEX workspace_locations_location_id_idx
    ON public.workspace_locations (location_id);

CREATE INDEX workspace_locations_active_workspace_idx
    ON public.workspace_locations (organization_id, workspace_id)
    WHERE status = 'active';

-- A workspace can have only one active primary location.
CREATE UNIQUE INDEX workspace_locations_one_active_primary_idx
    ON public.workspace_locations (organization_id, workspace_id)
    WHERE is_primary = TRUE
      AND status = 'active';