-- ChariTask Foundation: Organizational Role Assignments
-- Connects people to organizational roles.
-- Organizational roles describe what a person is within
-- the organization and do not grant system permissions.

CREATE TABLE public.organizational_role_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,
    organizational_role_id UUID NOT NULL,

    status TEXT NOT NULL DEFAULT 'active',

    is_primary BOOLEAN NOT NULL DEFAULT FALSE,

    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    -- Prevent duplicate assignments.
    CONSTRAINT organizational_role_assignments_unique
        UNIQUE (
            organization_id,
            person_id,
            organizational_role_id
        ),

    -- Person must belong to this organization.
    CONSTRAINT organizational_role_assignments_organization_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons (organization_id, id),

    -- Organizational role must belong to this organization.
    CONSTRAINT organizational_role_assignments_organization_role_fkey
        FOREIGN KEY (organization_id, organizational_role_id)
        REFERENCES public.organizational_roles (organization_id, id),

    CONSTRAINT organizational_role_assignments_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT organizational_role_assignments_dates_check
        CHECK (
            ended_at IS NULL
            OR ended_at >= assigned_at
        )
);

CREATE INDEX organizational_role_assignments_person_id_idx
    ON public.organizational_role_assignments (person_id);

CREATE INDEX organizational_role_assignments_role_id_idx
    ON public.organizational_role_assignments (organizational_role_id);

CREATE INDEX organizational_role_assignments_active_person_idx
    ON public.organizational_role_assignments (
        organization_id,
        person_id
    )
    WHERE status = 'active';

-- A person can have only one active primary organizational role.
CREATE UNIQUE INDEX organizational_role_assignments_one_active_primary_idx
    ON public.organizational_role_assignments (
        organization_id,
        person_id
    )
    WHERE is_primary = TRUE
      AND status = 'active';