-- Add separate phone fields for the location itself
-- and for the location's primary contact.

ALTER TABLE public.locations
ADD COLUMN IF NOT EXISTS phone_extension TEXT,
ADD COLUMN IF NOT EXISTS contact_phone TEXT,
ADD COLUMN IF NOT EXISTS contact_phone_extension TEXT;

COMMENT ON COLUMN public.locations.phone_extension IS
    'Optional extension for the location main phone number.';

COMMENT ON COLUMN public.locations.contact_phone IS
    'Optional direct phone number for the location primary contact.';

COMMENT ON COLUMN public.locations.contact_phone_extension IS
    'Optional extension for the location primary contact phone number.';