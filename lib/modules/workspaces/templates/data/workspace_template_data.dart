import 'package:flutter/material.dart';

class WorkspaceTemplate {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  /// Accent color used for this template's icon and selected state.
  final Color accentColor;

  /// Light background used behind the icon when the card is not selected.
  final Color iconBackgroundColor;

  const WorkspaceTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.iconBackgroundColor,
  });
}

/// Mission & Community
///
/// Focused on direct mission engagement, volunteers, community,
/// and donor relationships.
const List<WorkspaceTemplate> missionCommunityTemplates = [
  WorkspaceTemplate(
    id: 'volunteer_coordinator',
    title: 'Volunteer Coordinator',
    description: 'Manage volunteers, shifts, and engagement initiatives.',
    icon: Icons.volunteer_activism_outlined,
    accentColor: Color(0xFF7C4DFF),
    iconBackgroundColor: Color(0xFFF1EDFF),
  ),
  WorkspaceTemplate(
    id: 'community_organizer',
    title: 'Community Organizer',
    description: 'Organize events, mobilize supporters, and drive impact.',
    icon: Icons.groups_outlined,
    accentColor: Color(0xFF5B9B6B),
    iconBackgroundColor: Color(0xFFEDF7EF),
  ),
  WorkspaceTemplate(
    id: 'donations_coordinator',
    title: 'Donations Coordinator',
    description: 'Track donations, manage donors, and run giving drives.',
    icon: Icons.volunteer_activism,
    accentColor: Color(0xFFB78A2C),
    iconBackgroundColor: Color(0xFFFBF5E7),
  ),
];

/// Fundraising & Programs
///
/// Focused on fundraising strategy, programs, projects,
/// and day-to-day program operations.
const List<WorkspaceTemplate> fundraisingProgramsTemplates = [
  WorkspaceTemplate(
    id: 'fundraising_manager',
    title: 'Fundraising Manager',
    description:
        'Coordinate fundraising campaigns, manage donor pipelines, and track giving progress.',
    icon: Icons.volunteer_activism_outlined,
    accentColor: Color(0xFF8B5E9E),
    iconBackgroundColor: Color(0xFFF5EFF7),
  ),
  WorkspaceTemplate(
    id: 'project_manager',
    title: 'Project Manager',
    description: 'Plan projects, track tasks, and manage timelines.',
    icon: Icons.assignment_outlined,
    accentColor: Color(0xFF5B7FA3),
    iconBackgroundColor: Color(0xFFEEF4F9),
  ),
  WorkspaceTemplate(
    id: 'operations_admin',
    title: 'Operations Admin',
    description: 'Oversee daily operations, processes, and workflows.',
    icon: Icons.settings_outlined,
    accentColor: Color(0xFF4C8B8B),
    iconBackgroundColor: Color(0xFFEDF7F7),
  ),
];

/// People, Resources & Compliance
///
/// Focused on internal organizational infrastructure,
/// people management, resources, records, and compliance.
const List<WorkspaceTemplate> peopleResourcesComplianceTemplates = [
  WorkspaceTemplate(
    id: 'people_hr_manager',
    title: 'People & HR Manager',
    description: 'Manage team records, onboarding, and HR tasks.',
    icon: Icons.people_outline,
    accentColor: Color(0xFFA65D76),
    iconBackgroundColor: Color(0xFFF9EEF2),
  ),
  WorkspaceTemplate(
    id: 'resource_manager',
    title: 'Resource Manager',
    description: 'Manage inventory, assets, and organizational resources.',
    icon: Icons.inventory_2_outlined,
    accentColor: Color(0xFFA47C35),
    iconBackgroundColor: Color(0xFFF8F3E8),
  ),
  WorkspaceTemplate(
    id: 'compliance_records_manager',
    title: 'Compliance & Records Manager',
    description:
        'Maintain organizational records, track compliance tasks, and manage required documentation.',
    icon: Icons.fact_check_outlined,
    accentColor: Color(0xFF6B7280),
    iconBackgroundColor: Color(0xFFF2F4F7),
  ),
];

/// Creative & Flexible
///
/// Covers outward-facing communications, marketing,
/// and the fully customizable workspace option.
const List<WorkspaceTemplate> creativeFlexibleTemplates = [
  WorkspaceTemplate(
    id: 'marketing_manager',
    title: 'Marketing Manager',
    description: 'Create campaigns, manage content, and grow your reach.',
    icon: Icons.campaign_outlined,
    accentColor: Color(0xFF7C4DFF),
    iconBackgroundColor: Color(0xFFF1EDFF),
  ),
  WorkspaceTemplate(
    id: 'communications_outreach_manager',
    title: 'Communications & Outreach Manager',
    description:
        'Manage newsletters, announcements, press releases, and community outreach communications.',
    icon: Icons.campaign_outlined,
    accentColor: Color(0xFF3F7FA3),
    iconBackgroundColor: Color(0xFFEEF6FA),
  ),
  WorkspaceTemplate(
    id: 'custom_workspace',
    title: 'Custom Workspace',
    description: 'Start from a blank workspace and build it your way.',
    icon: Icons.tune_outlined,
    accentColor: Color(0xFF7C4DFF),
    iconBackgroundColor: Color(0xFFF1EDFF),
  ),
];
