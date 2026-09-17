-- ChariTask Foundation: People Permissions
--
-- Defines the atomic capabilities used to authorize People management.
-- Permissions are global system definitions and are assigned to
-- organization-specific functional roles during provisioning.

INSERT INTO public.permissions (
    key,
    name,
    description,
    module
)
VALUES
(
    'people.view',
    'View People',
    'View people in the organization.',
    'people'
),
(
    'people.create',
    'Create People',
    'Create people in the organization.',
    'people'
),
(
    'people.edit',
    'Edit People',
    'Edit people information in the organization.',
    'people'
),
(
    'people.delete',
    'Delete People',
    'Archive people in the organization.',
    'people'
)
ON CONFLICT (key) DO NOTHING;