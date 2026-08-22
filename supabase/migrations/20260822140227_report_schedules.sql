-- ChariTask Foundation: Report Schedules
-- Defines reusable schedules for generating or delivering reports.
-- Delivery recipients and execution history are intentionally
-- separate concerns and can be added later.

CREATE TABLE public.report_schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    report_id UUID NOT NULL,

    name TEXT NOT NULL,
    description TEXT,

    -- IANA timezone, for example: America/New_York.
    timezone TEXT NOT NULL DEFAULT 'UTC',

    -- Standard cron expression controlling when the schedule runs.
    cron_expression TEXT NOT NULL,

    status TEXT NOT NULL DEFAULT 'active',

    last_run_at TIMESTAMPTZ,
    next_run_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    CONSTRAINT report_schedules_organization_report_fkey
        FOREIGN KEY (organization_id, report_id)
        REFERENCES public.reports (organization_id, id),

    CONSTRAINT report_schedules_status_check
        CHECK (status IN ('active', 'inactive')),

CONSTRAINT report_schedules_cron_expression_check
    CHECK (length(trim(cron_expression)) > 0),

CONSTRAINT report_schedules_organization_id_unique
    UNIQUE (organization_id, id)
);

CREATE INDEX report_schedules_report_id_idx
    ON public.report_schedules (report_id);

CREATE INDEX report_schedules_active_next_run_idx
    ON public.report_schedules (next_run_at)
    WHERE status = 'active';