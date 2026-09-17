-- ChariTask Foundation:
-- Store one weekly operating-hours entry for each day
-- of an organization-owned location.
--
-- Day of week:
-- 1 = Monday
-- 2 = Tuesday
-- 3 = Wednesday
-- 4 = Thursday
-- 5 = Friday
-- 6 = Saturday
-- 7 = Sunday

CREATE TABLE public.location_operating_hours (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL
        REFERENCES public.organizations(id)
        ON DELETE CASCADE,

    location_id UUID NOT NULL
        REFERENCES public.locations(id)
        ON DELETE CASCADE,

    day_of_week SMALLINT NOT NULL
        CHECK (day_of_week BETWEEN 1 AND 7),

    is_closed BOOLEAN NOT NULL DEFAULT false,

    opens_at TIME,
    closes_at TIME,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    created_by_person_id UUID
        REFERENCES public.persons(id)
        ON DELETE SET NULL,

    updated_by_person_id UUID
        REFERENCES public.persons(id)
        ON DELETE SET NULL,

    CONSTRAINT location_operating_hours_unique_day
        UNIQUE (location_id, day_of_week),

    CONSTRAINT location_operating_hours_times_check
        CHECK (
            is_closed = true
            OR (
                opens_at IS NOT NULL
                AND closes_at IS NOT NULL
            )
        )
);

CREATE INDEX location_operating_hours_location_idx
    ON public.location_operating_hours(location_id);

CREATE INDEX location_operating_hours_organization_idx
    ON public.location_operating_hours(organization_id);

CREATE TRIGGER location_operating_hours_set_audit_fields
    BEFORE INSERT OR UPDATE
    ON public.location_operating_hours
    FOR EACH ROW
    EXECUTE FUNCTION public.set_location_audit_fields();

ALTER TABLE public.location_operating_hours ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT, UPDATE, DELETE
    ON public.location_operating_hours
    TO authenticated;

CREATE POLICY "location_operating_hours_select"
    ON public.location_operating_hours
    FOR SELECT
    TO authenticated
    USING (
        has_organization_permission(
            (
                SELECT pai.person_id
                FROM person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'locations.view'
        )
        AND EXISTS (
            SELECT 1
            FROM public.locations l
            WHERE l.id = location_operating_hours.location_id
              AND l.organization_id = location_operating_hours.organization_id
        )
    );

CREATE POLICY "location_operating_hours_insert"
    ON public.location_operating_hours
    FOR INSERT
    TO authenticated
    WITH CHECK (
        has_organization_permission(
            (
                SELECT pai.person_id
                FROM person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'locations.create'
        )
        AND EXISTS (
            SELECT 1
            FROM public.locations l
            WHERE l.id = location_operating_hours.location_id
              AND l.organization_id = location_operating_hours.organization_id
        )
    );

CREATE POLICY "location_operating_hours_update"
    ON public.location_operating_hours
    FOR UPDATE
    TO authenticated
    USING (
        has_organization_permission(
            (
                SELECT pai.person_id
                FROM person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'locations.edit'
        )
        AND EXISTS (
            SELECT 1
            FROM public.locations l
            WHERE l.id = location_operating_hours.location_id
              AND l.organization_id = location_operating_hours.organization_id
        )
    )
    WITH CHECK (
        has_organization_permission(
            (
                SELECT pai.person_id
                FROM person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'locations.edit'
        )
        AND EXISTS (
            SELECT 1
            FROM public.locations l
            WHERE l.id = location_operating_hours.location_id
              AND l.organization_id = location_operating_hours.organization_id
        )
    );

CREATE POLICY "location_operating_hours_delete"
    ON public.location_operating_hours
    FOR DELETE
    TO authenticated
    USING (
        has_organization_permission(
            (
                SELECT pai.person_id
                FROM person_auth_identities pai
                WHERE pai.auth_user_id = auth.uid()
            ),
            organization_id,
            'locations.delete'
        )
        AND EXISTS (
            SELECT 1
            FROM public.locations l
            WHERE l.id = location_operating_hours.location_id
              AND l.organization_id = location_operating_hours.organization_id
        )
    );
