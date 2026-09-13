class OrganizationalRoleDefinition {
  const OrganizationalRoleDefinition({
    required this.name,
    required this.description,
    required this.focus,
  });

  final String name;
  final String description;
  final List<String> focus;
}

const organizationalRoleDefinitions = [
  OrganizationalRoleDefinition(
    name: 'Founder / Owner',
    description:
        'Leads or owns the organization and is responsible for its overall direction.',
    focus: [
      'Organization-wide leadership',
      'Strategy & direction',
      'Oversight & decision-making',
    ],
  ),
  OrganizationalRoleDefinition(
    name: 'Executive Leadership',
    description:
        'Provides senior leadership and helps guide organization-wide strategy and decisions.',
    focus: [
      'Strategic leadership',
      'Organization-wide decisions',
      'Executive oversight',
    ],
  ),
  OrganizationalRoleDefinition(
    name: 'Director',
    description:
        'Leads a major area of the organization and is responsible for its programs, people, or operations.',
    focus: [
      'Program or department leadership',
      'People & operations',
      'Planning & accountability',
    ],
  ),
  OrganizationalRoleDefinition(
    name: 'Manager',
    description:
        'Oversees day-to-day work, people, or operations within a team or area.',
    focus: [
      'Day-to-day operations',
      'Team coordination',
      'People & priorities',
    ],
  ),
  OrganizationalRoleDefinition(
    name: 'Team Lead',
    description:
        'Guides a team’s day-to-day work and helps coordinate people and priorities.',
    focus: ['Team guidance', 'Daily coordination', 'Work priorities'],
  ),
  OrganizationalRoleDefinition(
    name: 'Staff Member',
    description:
        'Performs day-to-day operational work and typically reports to a manager or team lead.',
    focus: [
      'Day-to-day operations',
      'Assigned responsibilities',
      'Team collaboration',
    ],
  ),
  OrganizationalRoleDefinition(
    name: 'Volunteer',
    description:
        'Contributes time and skills to support the organization’s mission without being a regular staff employee.',
    focus: ['Mission support', 'Assigned activities', 'Community involvement'],
  ),
  OrganizationalRoleDefinition(
    name: 'Board Member',
    description:
        'Provides governance, oversight, and strategic guidance as a member of the organization’s board.',
    focus: ['Governance', 'Strategic oversight', 'Organizational guidance'],
  ),
];
