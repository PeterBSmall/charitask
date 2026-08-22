-- ChariTask Foundation: Person Authentication Identities
-- Separates ChariTask people from Supabase authentication accounts.
-- A person may exist without a login.

CREATE TABLE public.person_auth_identities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    person_id UUID NOT NULL,
    auth_user_id UUID NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    linked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT person_auth_identities_person_id_fkey
        FOREIGN KEY (person_id)
        REFERENCES public.persons(id)
        ON DELETE CASCADE,

    CONSTRAINT person_auth_identities_auth_user_id_fkey
        FOREIGN KEY (auth_user_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT person_auth_identities_person_id_key
        UNIQUE (person_id),

    CONSTRAINT person_auth_identities_auth_user_id_key
        UNIQUE (auth_user_id)
);

CREATE INDEX person_auth_identities_person_id_idx
    ON public.person_auth_identities (person_id);

CREATE INDEX person_auth_identities_auth_user_id_idx
    ON public.person_auth_identities (auth_user_id);