ALTER TABLE public.groups
ADD COLUMN color TEXT NOT NULL DEFAULT '#5B4BC4';

ALTER TABLE public.groups
ADD CONSTRAINT groups_color_hex_check
CHECK (color ~ '^#[0-9A-Fa-f]{6}$');