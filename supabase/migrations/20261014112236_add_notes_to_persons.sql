-- Add optional notes to person records.
-- Existing records remain unchanged.

ALTER TABLE public.persons
ADD COLUMN IF NOT EXISTS notes TEXT;