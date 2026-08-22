-- ChariTask Foundation: Report Runs
-- Records each execution of a report, whether scheduled
-- or manually initiated. Delivery tracking can reference
-- a report run later.

CREATE TABLE public.report_runs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    report_id UUID NOT NULL,

    -- Optional because reports may be run manually
    -- without a saved schedule.
    report_schedule_id UUID,

    -- How this run was initiated.
    trigger_type TEXT NOT NULL DEFAULT 'schedule',

    status TEXT NOT NULL DEFAULT 'queued',

    requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,

    -- Snapshot of filters/configuration used for this run.
    configuration JSONB NOT NULL DEFAULT '{}'::jsonb,

    -- Optional execution result metadata.
    result JSONB,

    error_message TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,

    -- Report must belong to this organization.
    CONSTRAINT report_runs_organization_report_fkey
        FOREIGN KEY (organization_id, report_id)
        REFERENCES public.reports (organization_id, id),

    -- If scheduled, the schedule must belong to this organization.
    CONSTRAINT report_runs_organization_schedule_fkey
        FOREIGN KEY (organization_id, report_schedule_id)
        REFERENCES public.report_schedules (organization_id, id),

    -- If manually initiated by a person, that person must
    -- belong to this organization.
    CONSTRAINT report_runs_organization_created_by_fkey
        FOREIGN KEY (organization_id, created_by_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT report_runs_trigger_type_check
        CHECK (
            trigger_type IN (
                'schedule',
                'manual',
                'system'
            )
        ),

    CONSTRAINT report_runs_status_check
        CHECK (
            status IN (
                'queued',
                'running',
                'succeeded',
                'failed',
                'cancelled'
            )
        ),

    CONSTRAINT report_runs_dates_check
        CHECK (
            (started_at IS NULL OR started_at >= requested_at)
            AND
            (completed_at IS NULL OR started_at IS NULL OR completed_at >= started_at)
        ),

    -- A failed run should have an error message.
    CONSTRAINT report_runs_failed_error_check
        CHECK (
            status <> 'failed'
            OR error_message IS NOT NULL
        )
);

CREATE INDEX report_runs_report_id_idx
    ON public.report_runs (report_id);

CREATE INDEX report_runs_schedule_id_idx
    ON public.report_runs (report_schedule_id)
    WHERE report_schedule_id IS NOT NULL;

CREATE INDEX report_runs_status_idx
    ON public.report_runs (organization_id, status);

CREATE INDEX report_runs_recent_idx
    ON public.report_runs (
        organization_id,
        requested_at DESC
    );

CREATE INDEX report_runs_pending_idx
    ON public.report_runs (
        organization_id,
        requested_at
    )
    WHERE status IN ('queued', 'running');