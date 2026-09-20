-- ChariTask Foundation:
-- Create the unified workspace task system.

CREATE TABLE public.tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    workspace_id UUID NOT NULL,

    title TEXT NOT NULL,
    description TEXT,

    assigned_to_person_id UUID,
    created_by_person_id UUID,

    due_at TIMESTAMPTZ,

    status TEXT NOT NULL DEFAULT 'open',
    priority TEXT NOT NULL DEFAULT 'normal',

    completed_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT tasks_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id)
        ON DELETE CASCADE,

    CONSTRAINT tasks_workspace_organization_fkey
        FOREIGN KEY (organization_id, workspace_id)
        REFERENCES public.workspaces(organization_id, id)
        ON DELETE CASCADE,

    CONSTRAINT tasks_assigned_to_person_id_fkey
        FOREIGN KEY (assigned_to_person_id)
        REFERENCES public.persons(id)
        ON DELETE SET NULL,

    CONSTRAINT tasks_created_by_person_id_fkey
        FOREIGN KEY (created_by_person_id)
        REFERENCES public.persons(id)
        ON DELETE SET NULL,

    CONSTRAINT tasks_title_not_blank
        CHECK (NULLIF(TRIM(title), '') IS NOT NULL),

    CONSTRAINT tasks_status_check
        CHECK (status IN ('open', 'in_progress', 'completed', 'cancelled')),

    CONSTRAINT tasks_priority_check
        CHECK (priority IN ('low', 'normal', 'high', 'urgent'))
);

CREATE INDEX tasks_organization_id_idx
    ON public.tasks (organization_id);

CREATE INDEX tasks_workspace_id_idx
    ON public.tasks (workspace_id);

CREATE INDEX tasks_assigned_to_person_id_idx
    ON public.tasks (assigned_to_person_id);

CREATE INDEX tasks_due_at_idx
    ON public.tasks (due_at);

CREATE INDEX tasks_active_assigned_due_idx
    ON public.tasks (assigned_to_person_id, due_at)
    WHERE archived_at IS NULL
      AND status IN ('open', 'in_progress');

CREATE INDEX tasks_workspace_active_idx
    ON public.tasks (workspace_id)
    WHERE archived_at IS NULL;

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT, UPDATE, DELETE
ON public.tasks
TO authenticated;
