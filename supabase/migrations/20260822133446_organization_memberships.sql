-- ChariTask Foundation: Organization Memberships
-- Establishes the relationship between a person and an organization.
-- Membership is separate from authentication and authorization.

CREATE TABLE public.organization_memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    person_id UUID NOT NULL,

    status TEXT NOT NULL DEFAULT 'active',

    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ended_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    CONSTRAINT organization_memberships_organization_person_key
        UNIQUE (organization_id, person_id),

    CONSTRAINT organization_memberships_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    -- Organization-safe relationship:
    -- the person must belong to the same organization.
    CONSTRAINT organization_memberships_organization_person_fkey
        FOREIGN KEY (organization_id, person_id)
        REFERENCES public.persons(organization_id, id),

    CONSTRAINT organization_memberships_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT organization_memberships_dates_check
        CHECK (
            ended_at IS NULL
            OR ended_at >= started_at
        )
);

CREATE INDEX organization_memberships_person_id_idx
    ON public.organization_memberships (person_id);

CREATE INDEX organization_memberships_active_org_idx
    ON public.organization_memberships (organization_id)
    WHERE status = 'active';