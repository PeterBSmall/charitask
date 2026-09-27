-- ChariTask Groups
-- Align the database default with the current Groups module color.

ALTER TABLE public.groups
    ALTER COLUMN color SET DEFAULT '#06B6D4';