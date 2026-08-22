-- ChariTask Foundation: Report Recipients
-- Defines recipients for scheduled report delivery.
-- Supports internal people and external email recipients.

CREATE TABLE public.report_recipients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    report_schedule_id UUID NOT NULL,

    -- Internal person recipient or external email recipient.
    recipient_type TEXT NOT NULL,

    person_id UUID,
    email TEXT,

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    -- A recipient must be either an internal person
    -- or an external email, depending on recipient_type.
    CONSTRAINT report_recipients_type_check
        CHECK (
            recipient_type IN ('person', 'email')
        ),

    CONSTRAINT report_recipients_target_check
        CHECK (
            (recipient_type = 'person'
                AND person_id IS NOT NULL
                AND email IS NULL)
            OR
            (recipient_type = 'email'
                AND person_id IS NULL
                AND email IS NOT NULL)
        ),

    CONSTRAINT report_recipients_status_check
        CHECK (
            status IN ('active', 'inactive')
        ),

    -- Schedule must belong to the same organization.
    CONSTRAINT report_recipients_organization_schedule_fkey
        FOREIGN KEY (organization_id, report_schedule_id)
        REFERENCES public.report_schedules (organization_id, id),

    -- Internal person must belong to the same organization.
    CONSTRAINT report_recipients_organization_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),

    -- Prevent duplicate recipients on the same schedule.
    CONSTRAINT report_recipients_unique_person
        UNIQUE NULLS NOT DISTINCT (
            organization_id,
            report_schedule_id,
            recipient_type,
            person_id
        )
);

CREATE INDEX report_recipients_schedule_id_idx
    ON public.report_recipients (report_schedule_id);

CREATE INDEX report_recipients_person_id_idx
    ON public.report_recipients (person_id)
    WHERE person_id IS NOT NULL;

CREATE INDEX report_recipients_active_schedule_idx
    ON public.report_recipients (
        organization_id,
        report_schedule_id
    )
    WHERE status = 'active';