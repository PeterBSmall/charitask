import 'package:flutter/material.dart';

import 'package:charitask/domain/organization/organization_type.dart';

import 'organization_type_option.dart';

const organizationTypes = [
  OrganizationTypeOption(
    type: OrganizationType.nonprofit,
    icon: Icons.favorite_outline,
    title: 'Nonprofit',
    subtitle: 'Mission-driven organizations serving their communities.',
    heroTitle: 'Building stronger communities.',
    heroSubtitle:
        'Every nonprofit begins with people who want to make a difference.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.church,
    icon: Icons.church_outlined,
    title: 'Church / Faith Organization',
    subtitle:
        'Faith communities connecting people through worship and service.',
    heroTitle: 'Growing faith together.',
    heroSubtitle:
        'Technology that helps ministries focus on people, not paperwork.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.school,
    icon: Icons.school_outlined,
    title: 'School / Educational Organization',
    subtitle: 'Organizations dedicated to education and lifelong learning.',
    heroTitle: 'Empowering the next generation.',
    heroSubtitle:
        'Organize students, staff and volunteers in one connected workspace.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.municipality,
    icon: Icons.account_balance_outlined,
    title: 'Municipality / Public Service',
    subtitle:
        'Serving citizens through public programs and community services.',
    heroTitle: 'Serving every citizen.',
    heroSubtitle:
        'Coordinate departments, staff and volunteers with confidence.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.business,
    icon: Icons.business_outlined,
    title: 'Business / Company',
    subtitle: 'Purpose-driven companies creating positive impact.',
    heroTitle: 'People make great organizations.',
    heroSubtitle: 'Bring your teams, projects and mission together.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.healthcare,
    icon: Icons.local_hospital_outlined,
    title: 'Healthcare Organization',
    subtitle: 'Hospitals, clinics and health-focused organizations.',
    heroTitle: 'Supporting healthier communities.',
    heroSubtitle: 'Coordinate people and programs with compassion.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.artsCulture,
    icon: Icons.palette_outlined,
    title: 'Arts & Cultural Organization',
    subtitle: 'Museums, theaters, galleries and cultural institutions.',
    heroTitle: 'Creativity inspires communities.',
    heroSubtitle: 'Bring artists, volunteers and audiences together.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.foundation,
    icon: Icons.volunteer_activism_outlined,
    title: 'Foundation / Grantmaker',
    subtitle: 'Organizations investing in meaningful change.',
    heroTitle: 'Creating lasting impact.',
    heroSubtitle: 'Manage initiatives that strengthen communities.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.association,
    icon: Icons.groups_outlined,
    title: 'Association / Membership Organization',
    subtitle: 'Professional, civic and membership organizations.',
    heroTitle: 'Connecting members.',
    heroSubtitle: 'Build stronger communities through collaboration.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.communityGroup,
    icon: Icons.diversity_3_outlined,
    title: 'Community Group',
    subtitle: 'Neighborhood groups, clubs and local initiatives.',
    heroTitle: 'Communities thrive together.',
    heroSubtitle: 'Organize people around a shared purpose.',
  ),

  OrganizationTypeOption(
    type: OrganizationType.other,
    icon: Icons.more_horiz,
    title: 'Other',
    subtitle: "Choose this if your organization doesn't fit a category above.",
    heroTitle: 'Every mission matters.',
    heroSubtitle:
        "We'll help you build a workspace that fits your organization.",
  ),
];
