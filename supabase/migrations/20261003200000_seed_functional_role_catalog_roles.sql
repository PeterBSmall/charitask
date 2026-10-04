-- ============================================================
-- Milestone 1C
-- Seed Master Functional Role Catalog Roles
-- ============================================================

INSERT INTO public.functional_role_catalog_roles (
    catalog_category_id,
    name,
    slug,
    description,
    status
)
SELECT
    c.id,
    r.name,
    r.slug,
    r.description,
    'active'
FROM (
    VALUES

    -- ========================================================
    -- Administration
    -- ========================================================
    (
        'administration',
        'System Administrator',
        'system-administrator',
        'Full administrative access to the organization.'
    ),
    (
        'administration',
        'Administrative Coordinator',
        'administrative-coordinator',
        'Coordinates administrative processes, records, systems, and organizational support.'
    ),
    (
        'administration',
        'Office Administrator',
        'office-administrator',
        'Manages day-to-day office administration and organizational support.'
    ),
    (
        'administration',
        'Executive Assistant',
        'executive-assistant',
        'Provides administrative and organizational support to executive leadership.'
    ),

    -- ========================================================
    -- Leadership
    -- ========================================================
    (
        'leadership',
        'Executive Director',
        'executive-director',
        'Provides overall organizational leadership, strategy, and operational direction.'
    ),
    (
        'leadership',
        'Chief Executive Officer',
        'chief-executive-officer',
        'Provides executive leadership and organizational direction.'
    ),
    (
        'leadership',
        'Operations Director',
        'operations-director',
        'Leads organizational operations, processes, and operational performance.'
    ),
    (
        'leadership',
        'Program Director',
        'program-director',
        'Provides leadership and strategic direction for organizational programs and services.'
    ),
    (
        'leadership',
        'Department Manager',
        'department-manager',
        'Leads and manages a department, team, or organizational function.'
    ),

    -- ========================================================
    -- Finance
    -- ========================================================
    (
        'finance',
        'Finance Director',
        'finance-director',
        'Leads financial strategy, financial operations, and organizational financial management.'
    ),
    (
        'finance',
        'Finance Manager',
        'finance-manager',
        'Manages financial operations, reporting, budgeting, and financial processes.'
    ),
    (
        'finance',
        'Accountant',
        'accountant',
        'Performs accounting, financial reporting, reconciliation, and related financial activities.'
    ),
    (
        'finance',
        'Bookkeeper',
        'bookkeeper',
        'Maintains financial records, transactions, reconciliations, and bookkeeping processes.'
    ),
    (
        'finance',
        'Finance Assistant',
        'finance-assistant',
        'Provides administrative and operational support for financial activities.'
    ),

    -- ========================================================
    -- Fundraising & Development
    -- ========================================================
    (
        'fundraising-development',
        'Development Director',
        'development-director',
        'Leads fundraising, donor development, grants, and resource development strategy.'
    ),
    (
        'fundraising-development',
        'Development Manager',
        'development-manager',
        'Manages fundraising and development programs, campaigns, and donor activities.'
    ),
    (
        'fundraising-development',
        'Fundraising Coordinator',
        'fundraising-coordinator',
        'Coordinates fundraising campaigns, activities, events, and related processes.'
    ),
    (
        'fundraising-development',
        'Grant Manager',
        'grant-manager',
        'Manages grant development, submissions, compliance, reporting, and grant relationships.'
    ),
    (
        'fundraising-development',
        'Donor Relations Coordinator',
        'donor-relations-coordinator',
        'Coordinates donor communications, stewardship, engagement, and relationship support.'
    ),

    -- ========================================================
    -- Volunteer Services
    -- ========================================================
    (
        'volunteer-services',
        'Volunteer Manager',
        'volunteer-manager',
        'Leads volunteer recruitment, engagement, coordination, and volunteer programs.'
    ),
    (
        'volunteer-services',
        'Volunteer Coordinator',
        'volunteer-coordinator',
        'Coordinates volunteer scheduling, communication, placement, and support.'
    ),
    (
        'volunteer-services',
        'Volunteer Engagement Coordinator',
        'volunteer-engagement-coordinator',
        'Supports volunteer engagement, recognition, communication, and retention.'
    ),

    -- ========================================================
    -- Programs & Services
    -- ========================================================
    (
        'programs-services',
        'Program Manager',
        'program-manager',
        'Manages program operations, delivery, staff, participants, and program outcomes.'
    ),
    (
        'programs-services',
        'Program Coordinator',
        'program-coordinator',
        'Coordinates program activities, services, schedules, and participant support.'
    ),
    (
        'programs-services',
        'Case Manager',
        'case-manager',
        'Provides case management, participant support, coordination, and service navigation.'
    ),
    (
        'programs-services',
        'Participant Services Coordinator',
        'participant-services-coordinator',
        'Coordinates participant services, communication, scheduling, and support.'
    ),
    (
        'programs-services',
        'Outreach Coordinator',
        'outreach-coordinator',
        'Coordinates community outreach, engagement, communications, and service connections.'
    ),

    -- ========================================================
    -- Retail Operations
    -- ========================================================
    (
        'retail-operations',
        'ReStore Manager',
        'restore-manager',
        'Leads ReStore operations, staff, sales, donations, merchandising, and customer service.'
    ),
    (
        'retail-operations',
        'Assistant Store Manager',
        'assistant-store-manager',
        'Supports store leadership, daily operations, staff, sales, and customer service.'
    ),
    (
        'retail-operations',
        'Retail Operations Coordinator',
        'retail-operations-coordinator',
        'Coordinates retail operations, processes, schedules, and store activities.'
    ),
    (
        'retail-operations',
        'Donation Coordinator',
        'donation-coordinator',
        'Coordinates incoming donations, donor communication, scheduling, and donation processing.'
    ),
    (
        'retail-operations',
        'Sales Associate',
        'sales-associate',
        'Supports retail sales, customer service, merchandising, and store operations.'
    ),
    (
        'retail-operations',
        'Merchandising Coordinator',
        'merchandising-coordinator',
        'Coordinates product presentation, merchandising, displays, and inventory flow.'
    ),
    (
        'retail-operations',
        'Warehouse Coordinator',
        'warehouse-coordinator',
        'Coordinates warehouse operations, inventory flow, receiving, storage, and logistics.'
    ),

    -- ========================================================
    -- Facilities & Operations
    -- ========================================================
    (
        'facilities-operations',
        'Facilities Manager',
        'facilities-manager',
        'Leads facilities, property, maintenance, safety, and related operational activities.'
    ),
    (
        'facilities-operations',
        'Facilities Coordinator',
        'facilities-coordinator',
        'Coordinates facilities, property, maintenance requests, vendors, and operational support.'
    ),
    (
        'facilities-operations',
        'Maintenance Coordinator',
        'maintenance-coordinator',
        'Coordinates maintenance activities, work orders, repairs, and maintenance resources.'
    ),
    (
        'facilities-operations',
        'Logistics Coordinator',
        'logistics-coordinator',
        'Coordinates logistics, transportation, scheduling, deliveries, and operational movement.'
    ),
    (
        'facilities-operations',
        'Transportation Coordinator',
        'transportation-coordinator',
        'Coordinates organizational transportation, vehicle scheduling, and transportation logistics.'
    ),
    (
        'facilities-operations',
        'Construction Manager',
        'construction-manager',
        'Manages construction activities, projects, contractors, schedules, and construction operations.'
    ),

    -- ========================================================
    -- Human Resources
    -- ========================================================
    (
        'human-resources',
        'Human Resources Manager',
        'human-resources-manager',
        'Leads human resources operations, employee support, policies, and organizational people practices.'
    ),
    (
        'human-resources',
        'Human Resources Coordinator',
        'human-resources-coordinator',
        'Coordinates human resources processes, records, employee support, and HR administration.'
    ),
    (
        'human-resources',
        'Talent Acquisition Coordinator',
        'talent-acquisition-coordinator',
        'Coordinates recruiting, candidate communication, interviews, and hiring processes.'
    ),

    -- ========================================================
    -- Marketing & Communications
    -- ========================================================
    (
        'marketing-communications',
        'Communications Manager',
        'communications-manager',
        'Leads organizational communications, messaging, content, and communication strategy.'
    ),
    (
        'marketing-communications',
        'Marketing Coordinator',
        'marketing-coordinator',
        'Coordinates marketing campaigns, materials, promotions, and marketing activities.'
    ),
    (
        'marketing-communications',
        'Social Media Coordinator',
        'social-media-coordinator',
        'Coordinates social media content, publishing, engagement, and social communication.'
    ),
    (
        'marketing-communications',
        'Public Relations Coordinator',
        'public-relations-coordinator',
        'Coordinates public relations, media communications, announcements, and community visibility.'
    )

) AS r(category_slug, name, slug, description)
JOIN public.functional_role_catalog_categories c
    ON c.slug = r.category_slug;