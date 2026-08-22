-- ChariTask Foundation: Report Access
-- Controls access to organization-owned reports.
-- Access may be granted to a person, organizational role,
-- system role, functional role, permission tier, or workspace.

CREATE TABLE public.report_access (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    report_id UUID NOT NULL,

    -- The type of subject receiving access.
    subject_type TEXT NOT NULL,

    -- The ID of the subject receiving access.
    subject_id UUID NOT NULL,

    -- Level of access granted.
    access_level TEXT NOT NULL DEFAULT 'view',

    status TEXT NOT NULL DEFAULT 'active',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    CONSTRAINT report_access_unique
        UNIQUE (
            organization_id,
            report_id,
            subject_type,
            subject_id
        ),

    -- Report must belong to the same organization.
    CONSTRAINT report_access_organization_report_fkey
        FOREIGN KEY (organization_id, report_id)
        REFERENCES public.reports (organization_id, id),

    CONSTRAINT report_access_subject_type_check
        CHECK (
            subject_type IN (
                'person',
                'organizational_role',
                'role',
                'functional_role',
                'permission_tier',
                'workspace'
            )
        ),

    CONSTRAINT report_access_level_check
        CHECK (
            access_level IN (
                'view',
                'manage'
            )
        ),

    CONSTRAINT report_access_status_check
        CHECK (
            status IN ('active', 'inactive')
        )
);

CREATE INDEX report_access_report_id_idx
    ON public.report_access (report_id);

CREATE INDEX report_access_subject_idx
    ON public.report_access (
        organization_id,
        subject_type,
        subject_id
    );

CREATE INDEX report_access_active_report_idx
    ON public.report_access (
        organization_id,
        report_id
    )
    WHERE status = 'active';