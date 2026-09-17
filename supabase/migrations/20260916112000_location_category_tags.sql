-- ChariTask: Organization Location Category Tags
--
-- Location Types are controlled system values.
-- Category Tags are organization-owned, configurable values.
--
-- Example:
--   Location Type: Retail
--   Category Tags: Thrift Store, Headquarters
--
-- Tags are intentionally separate from location_type so an organization
-- can describe a location using multiple categories.

-- ============================================================
-- 1. ORGANIZATION LOCATION CATEGORY TAGS
-- ============================================================

CREATE TABLE public.organization_location_category_tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'active',
    created_by_person_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_by_person_id UUID,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    archived_at TIMESTAMPTZ,

    CONSTRAINT organization_location_category_tags_organization_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    CONSTRAINT organization_location_category_tags_created_by_person_fkey
        FOREIGN KEY (organization_id, created_by_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT organization_location_category_tags_updated_by_person_fkey
        FOREIGN KEY (organization_id, updated_by_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT organization_location_category_tags_organization_slug_key
        UNIQUE (organization_id, slug),

    CONSTRAINT organization_location_category_tags_status_check
        CHECK (status IN ('active', 'inactive')),

    CONSTRAINT organization_location_category_tags_organization_id_id_key
        UNIQUE (organization_id, id)
);

CREATE INDEX organization_location_category_tags_organization_id_idx
    ON public.organization_location_category_tags (organization_id);

CREATE INDEX organization_location_category_tags_active_idx
    ON public.organization_location_category_tags (organization_id)
    WHERE archived_at IS NULL;


-- ============================================================
-- 2. LOCATION ↔ CATEGORY TAG ASSIGNMENTS
-- ============================================================

CREATE TABLE public.location_category_tag_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id UUID NOT NULL,
    location_id UUID NOT NULL,
    tag_id UUID NOT NULL,
    created_by_person_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT location_category_tag_assignments_organization_fkey
        FOREIGN KEY (organization_id)
        REFERENCES public.organizations(id),

    CONSTRAINT location_category_tag_assignments_location_fkey
        FOREIGN KEY (organization_id, location_id)
        REFERENCES public.locations (organization_id, id),

    CONSTRAINT location_category_tag_assignments_tag_fkey
        FOREIGN KEY (organization_id, tag_id)
        REFERENCES public.organization_location_category_tags (
            organization_id,
            id
        ),

    CONSTRAINT location_category_tag_assignments_created_by_person_fkey
        FOREIGN KEY (organization_id, created_by_person_id)
        REFERENCES public.persons (organization_id, id),

    CONSTRAINT location_category_tag_assignments_unique
        UNIQUE (organization_id, location_id, tag_id)
);

CREATE INDEX location_category_tag_assignments_organization_idx
    ON public.location_category_tag_assignments (organization_id);

CREATE INDEX location_category_tag_assignments_location_idx
    ON public.location_category_tag_assignments (organization_id, location_id);

CREATE INDEX location_category_tag_assignments_tag_idx
    ON public.location_category_tag_assignments (organization_id, tag_id);


-- ============================================================
-- 3. AUDIT TRIGGER FOR TAGS
-- ============================================================

CREATE OR REPLACE FUNCTION public.set_location_category_tag_audit_fields()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_person_id UUID;
BEGIN
    SELECT person_id
    INTO v_person_id
    FROM public.person_auth_identities
    WHERE auth_user_id = auth.uid()
    LIMIT 1;

    IF TG_OP = 'INSERT' THEN
        IF v_person_id IS NOT NULL THEN
            NEW.created_by_person_id := v_person_id;
            NEW.updated_by_person_id := v_person_id;
        END IF;

        NEW.created_at := COALESCE(NEW.created_at, NOW());
        NEW.updated_at := COALESCE(NEW.updated_at, NOW());

        RETURN NEW;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        IF v_person_id IS NOT NULL THEN
            NEW.updated_by_person_id := v_person_id;
        END IF;

        NEW.updated_at := NOW();

        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS organization_location_category_tags_audit_trigger
    ON public.organization_location_category_tags;

CREATE TRIGGER organization_location_category_tags_audit_trigger
BEFORE INSERT OR UPDATE
ON public.organization_location_category_tags
FOR EACH ROW
EXECUTE FUNCTION public.set_location_category_tag_audit_fields();


-- ============================================================
-- 4. AUDIT TRIGGER FOR LOCATION ↔ TAG ASSIGNMENTS
-- ============================================================

CREATE OR REPLACE FUNCTION public.set_location_category_tag_assignment_audit_fields()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_person_id UUID;
BEGIN
    SELECT person_id
    INTO v_person_id
    FROM public.person_auth_identities
    WHERE auth_user_id = auth.uid()
    LIMIT 1;

    IF v_person_id IS NOT NULL THEN
        NEW.created_by_person_id := v_person_id;
    END IF;

    NEW.created_at := COALESCE(NEW.created_at, NOW());

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS location_category_tag_assignments_audit_trigger
    ON public.location_category_tag_assignments;

CREATE TRIGGER location_category_tag_assignments_audit_trigger
BEFORE INSERT
ON public.location_category_tag_assignments
FOR EACH ROW
EXECUTE FUNCTION public.set_location_category_tag_assignment_audit_fields();


-- ============================================================
-- 5. ROW LEVEL SECURITY — TAGS
-- ============================================================

ALTER TABLE public.organization_location_category_tags
    ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS organization_location_category_tags_select
    ON public.organization_location_category_tags;

CREATE POLICY organization_location_category_tags_select
ON public.organization_location_category_tags
FOR SELECT
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
            LIMIT 1
        ),
        organization_id,
        'locations.view'
    )
);

DROP POLICY IF EXISTS organization_location_category_tags_insert
    ON public.organization_location_category_tags;

CREATE POLICY organization_location_category_tags_insert
ON public.organization_location_category_tags
FOR INSERT
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
            LIMIT 1
        ),
        organization_id,
        'locations.edit'
    )
);

DROP POLICY IF EXISTS organization_location_category_tags_update
    ON public.organization_location_category_tags;

CREATE POLICY organization_location_category_tags_update
ON public.organization_location_category_tags
FOR UPDATE
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
            LIMIT 1
        ),
        organization_id,
        'locations.edit'
    )
)
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
            LIMIT 1
        ),
        organization_id,
        'locations.edit'
    )
);

DROP POLICY IF EXISTS organization_location_category_tags_delete
    ON public.organization_location_category_tags;

CREATE POLICY organization_location_category_tags_delete
ON public.organization_location_category_tags
FOR DELETE
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
            LIMIT 1
        ),
        organization_id,
        'locations.edit'
    )
);


-- ============================================================
-- 6. ROW LEVEL SECURITY — LOCATION ↔ TAG ASSIGNMENTS
-- ============================================================

ALTER TABLE public.location_category_tag_assignments
    ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS location_category_tag_assignments_select
    ON public.location_category_tag_assignments;

CREATE POLICY location_category_tag_assignments_select
ON public.location_category_tag_assignments
FOR SELECT
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
            LIMIT 1
        ),
        organization_id,
        'locations.view'
    )
);

DROP POLICY IF EXISTS location_category_tag_assignments_insert
    ON public.location_category_tag_assignments;

CREATE POLICY location_category_tag_assignments_insert
ON public.location_category_tag_assignments
FOR INSERT
WITH CHECK (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
            LIMIT 1
        ),
        organization_id,
        'locations.create'
    )
    OR
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
            LIMIT 1
        ),
        organization_id,
        'locations.edit'
    )
);

DROP POLICY IF EXISTS location_category_tag_assignments_delete
    ON public.location_category_tag_assignments;

CREATE POLICY location_category_tag_assignments_delete
ON public.location_category_tag_assignments
FOR DELETE
USING (
    public.has_organization_permission(
        (
            SELECT pai.person_id
            FROM public.person_auth_identities pai
            WHERE pai.auth_user_id = auth.uid()
            LIMIT 1
        ),
        organization_id,
        'locations.edit'
    )
);