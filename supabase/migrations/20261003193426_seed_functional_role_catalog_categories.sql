-- ============================================================
-- Seed Functional Role Master Catalog Categories
-- ============================================================

INSERT INTO public.functional_role_catalog_categories (
    name,
    slug,
    description,
    sort_order,
    status
)
VALUES
(
    'Administration',
    'administration',
    'Organizational administration, systems, governance, and administrative support.',
    1,
    'active'
),
(
    'Leadership',
    'leadership',
    'Organizational leadership, strategy, management, and executive responsibilities.',
    2,
    'active'
),
(
    'Finance',
    'finance',
    'Financial management, accounting, budgeting, and financial operations.',
    3,
    'active'
),
(
    'Fundraising & Development',
    'fundraising-development',
    'Fundraising, donor relations, grants, development, and resource generation.',
    4,
    'active'
),
(
    'Volunteer Services',
    'volunteer-services',
    'Volunteer recruitment, coordination, engagement, scheduling, and support.',
    5,
    'active'
),
(
    'Programs & Services',
    'programs-services',
    'Programs, services, participant support, community impact, and program delivery.',
    6,
    'active'
),
(
    'Retail Operations',
    'retail-operations',
    'Retail store operations, merchandising, sales, donations, and customer service.',
    7,
    'active'
),
(
    'Facilities & Operations',
    'facilities-operations',
    'Facilities, properties, maintenance, logistics, safety, and operational support.',
    8,
    'active'
),
(
    'Human Resources',
    'human-resources',
    'Human resources, recruiting, employee support, and organizational people practices.',
    9,
    'active'
),
(
    'Marketing & Communications',
    'marketing-communications',
    'Marketing, communications, public relations, social media, and organizational messaging.',
    10,
    'active'
);