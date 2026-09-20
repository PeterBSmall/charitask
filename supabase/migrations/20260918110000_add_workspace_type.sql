-- ChariTask Foundation:
-- Add explicit workspace context.

ALTER TABLE public.workspaces
ADD COLUMN workspace_type TEXT NOT NULL DEFAULT 'organization';

ALTER TABLE public.workspaces
ADD CONSTRAINT workspaces_workspace_type_check
CHECK (workspace_type IN ('personal', 'organization'));
