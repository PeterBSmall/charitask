-- ChariTask Foundation: Person Preferences
--
-- Stores preferences belonging to an individual person.
-- Personal preferences are not organization-scoped.

-- ============================================================
-- 1. Create person preferences
-- ============================================================

CREATE TABLE public.person_preferences (
    person_id UUID PRIMARY KEY,
    hero_image_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_preferences_person_id_fkey
        FOREIGN KEY (person_id)
        REFERENCES public.persons(id)
        ON DELETE CASCADE
);

-- ============================================================
-- 2. Enable Row Level Security
-- ============================================================

ALTER TABLE public.person_preferences ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 3. SELECT policy
-- ============================================================

DROP POLICY IF EXISTS "person_preferences_select_policy"
ON public.person_preferences;

CREATE POLICY "person_preferences_select_policy"
ON public.person_preferences
FOR SELECT
TO authenticated
USING (
    person_id = (
        SELECT pai.person_id
        FROM public.person_auth_identities pai
        WHERE pai.auth_user_id = auth.uid()
    )
);

-- ============================================================
-- 4. INSERT policy
-- ============================================================

DROP POLICY IF EXISTS "person_preferences_insert_policy"
ON public.person_preferences;

CREATE POLICY "person_preferences_insert_policy"
ON public.person_preferences
FOR INSERT
TO authenticated
WITH CHECK (
    person_id = (
        SELECT pai.person_id
        FROM public.person_auth_identities pai
        WHERE pai.auth_user_id = auth.uid()
    )
);

-- ============================================================
-- 5. UPDATE policy
-- ============================================================

DROP POLICY IF EXISTS "person_preferences_update_policy"
ON public.person_preferences;

CREATE POLICY "person_preferences_update_policy"
ON public.person_preferences
FOR UPDATE
TO authenticated
USING (
    person_id = (
        SELECT pai.person_id
        FROM public.person_auth_identities pai
        WHERE pai.auth_user_id = auth.uid()
    )
)
WITH CHECK (
    person_id = (
        SELECT pai.person_id
        FROM public.person_auth_identities pai
        WHERE pai.auth_user_id = auth.uid()
    )
);

-- ============================================================
-- 6. DELETE policy
-- ============================================================

DROP POLICY IF EXISTS "person_preferences_delete_policy"
ON public.person_preferences;

CREATE POLICY "person_preferences_delete_policy"
ON public.person_preferences
FOR DELETE
TO authenticated
USING (
    person_id = (
        SELECT pai.person_id
        FROM public.person_auth_identities pai
        WHERE pai.auth_user_id = auth.uid()
    )
);
