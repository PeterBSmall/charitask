CREATE OR REPLACE FUNCTION public.create_personal_workspace(
  p_name TEXT,
  p_description TEXT,
  p_template_id TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  result JSONB;
  v_workspace_id UUID;
BEGIN
  result := public.create_personal_workspace(
    p_name => p_name,
    p_description => p_description
  );

  v_workspace_id := (result ->> 'workspace_id')::UUID;

  UPDATE public.workspaces
  SET
    template_id = p_template_id,
    updated_at = NOW()
  WHERE id = v_workspace_id;

  RETURN result ||
    jsonb_build_object(
      'template_id', p_template_id
    );
END;
$$;