-- ChariTask Foundation:
-- Restore the Persons table.
-- The original persons migration was recorded as applied
-- but contained no SQL in the production deployment.

CREATE TABLE public.persons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,

    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    preferred_name TEXT,

    email TEXT,
    phone TEXT,

    employment_type TEXT,
    status TEXT NOT NULL DEFAULT 'active',

    archived_at TIMESTAMPTZ,
    archived_by_person_id UUID,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    created_by_person_id UUID,
    updated_by_person_id UUID,

    CONSTRAINT persons_organization_id_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    CONSTRAINT persons_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT persons_archived_by_person_id_fkey
        FOREIGN KEY (archived_by_person_id)
        REFERENCES public.persons(id),

    CONSTRAINT persons_created_by_person_id_fkey
        FOREIGN KEY (created_by_person_id)
        REFERENCES public.persons(id),

    CONSTRAINT persons_updated_by_person_id_fkey
        FOREIGN KEY (updated_by_person_id)
        REFERENCES public.persons(id)
);

ALTER TABLE public.persons
    ADD CONSTRAINT persons_organization_id_id_key
    UNIQUE (organization_id, id);

CREATE INDEX persons_organization_id_idx
    ON public.persons (organization_id);

CREATE INDEX persons_active_organization_idx
    ON public.persons (organization_id)
    WHERE archived_at IS NULL;