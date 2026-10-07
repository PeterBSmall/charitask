import 'package:flutter/material.dart';

class OrganizationalRoleSummaryCard extends StatelessWidget {
  const OrganizationalRoleSummaryCard({
    super.key,
    required this.organizationalRole,
  });

  // Kept as organizationalRole for compatibility with the existing
  // OrganizationalRoleStep API. This value now represents Person Type.
  final String organizationalRole;

  String _description(String personType) {
    switch (personType) {
      case 'Founder / Owner':
        return 'Leads or owns the organization and is responsible for its overall direction.';

      case 'Executive Leadership':
        return 'Provides senior leadership and helps guide organization-wide strategy and decisions.';

      case 'Staff Member':
        return 'Performs ongoing work for the organization as a staff member.';

      case 'Volunteer':
        return 'Contributes time and skills to support the organization’s mission without being a regular staff employee.';

      case 'Board Member':
        return 'Provides governance, oversight, and strategic guidance as a member of the organization’s board.';

      case 'Donor':
        return 'Supports the organization through financial or in-kind contributions.';

      case 'Contractor':
        return 'Provides specialized services or expertise to the organization as an independent contractor.';

      case 'Partner Contact':
        return 'Represents a partner organization or community partner in an organizational relationship.';

      case 'Vendor Contact':
        return 'Represents a vendor or supplier that works with the organization.';

      case 'Community Member':
        return 'Participates in or connects with the organization as a member of the community.';

      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final description = _description(organizationalRole);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E0EC)),
      ),
      child: organizationalRole.isEmpty || description.isEmpty
          ? const _EmptySummary()
          : _PersonTypeSummary(
              personType: organizationalRole,
              description: description,
            ),
    );
  }
}

class _PersonTypeSummary extends StatelessWidget {
  const _PersonTypeSummary({
    required this.personType,
    required this.description,
  });

  final String personType;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PERSON TYPE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: Color(0xFF7C4DFF),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          personType,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF292333),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          description,
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
            color: Color(0xFF6F687A),
          ),
        ),
      ],
    );
  }
}

class _EmptySummary extends StatelessWidget {
  const _EmptySummary();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERSON TYPE',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: Color(0xFF7C4DFF),
          ),
        ),
        SizedBox(height: 18),
        Text(
          'Select a person type',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF292333),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Choose a person type to see a brief explanation of what it represents.',
          style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF6F687A)),
        ),
      ],
    );
  }
}
