-- ChariTask Group Locations
-- Associates Groups with one or more organization Locations.

CREATE TABLE public.group_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL,
    group_id UUID NOT NULL,
    location_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by_person_id UUID,

    CONSTRAINT group_locations_organization_group_location_key
        UNIQUE (organization_id, group_id, location_id),

    -- Group must belong to this organization.
    CONSTRAINT group_locations_organization_group_fkey
        FOREIGN KEY (organization_id, group_id)
        REFERENCES public.groups (organization_id, id),

    -- Location must belong to this organization.
    CONSTRAINT group_locations_organization_location_fkey
        FOREIGN KEY (organization_id, location_id)
        REFERENCES public.locations (organization_id, id),

    -- Creator must belong to this organization.
    CONSTRAINT group_locations_organization_created_by_fkey
        FOREIGN KEY (organization_id, created_by_person_id)
        REFERENCES public.persons (organization_id, id)
);

CREATE INDEX group_locations_group_id_idx
    ON public.group_locations (organization_id, group_id);

CREATE INDEX group_locations_location_id_idx
    ON public.group_locations (organization_id, location_id);

CREATE INDEX group_locations_created_by_idx
    ON public.group_locations (organization_id, created_by_person_id);


-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------

ALTER TABLE public.group_locations
ENABLE ROW LEVEL SECURITY;


CREATE POLICY "group_locations_select"
ON public.group_locations
FOR SELECT
USING (
    EXISTS (
        SELECT 1
        FROM public.person_auth_identities pai
        WHERE pai.auth_user_id = auth.uid()
          AND public.has_organization_permission(
              pai.person_id,
              organization_id,
              'groups.view'
          )
    )
);


CREATE POLICY "group_locations_insert"
ON public.group_locations
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM public.person_auth_identities pai
        WHERE pai.auth_user_id = auth.uid()
          AND public.has_organization_permission(
              pai.person_id,
              organization_id,
              'groups.manage'
          )
    )
);


CREATE POLICY "group_locations_delete"
ON public.group_locations
FOR DELETE
USING (
    EXISTS (
        SELECT 1
        FROM public.person_auth_identities pai
        WHERE pai.auth_user_id = auth.uid()
          AND public.has_organization_permission(
              pai.person_id,
              organization_id,
              'groups.manage'
          )
    )
);