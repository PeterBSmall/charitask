import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/widgets/add_person/credentials_compliance_card.dart';

import '../../../foundation/domain/models/functional_role.dart';
import '../../../foundation/widgets/functional_roles/functional_role_assignment_workspace.dart';

class AssignmentsStep extends StatefulWidget {
  final String organizationId;
  final List<FunctionalRole> selectedFunctionalRoles;
  final ValueChanged<List<FunctionalRole>> onFunctionalRolesChanged;

  final bool isVolunteer;
  final List<PersonCredentialDraft> credentials;
  final ValueChanged<List<PersonCredentialDraft>> onCredentialsChanged;

  const AssignmentsStep({
    super.key,
    required this.organizationId,
    required this.selectedFunctionalRoles,
    required this.onFunctionalRolesChanged,
    required this.isVolunteer,
    required this.credentials,
    required this.onCredentialsChanged,
  });

  @override
  State<AssignmentsStep> createState() => _AssignmentsStepState();
}

class _AssignmentsStepState extends State<AssignmentsStep> {
  bool _showFunctionalRoleWorkspace = false;

  void _openFunctionalRoles() {
    setState(() {
      _showFunctionalRoleWorkspace = true;
    });
  }

  void _closeFunctionalRoles() {
    setState(() {
      _showFunctionalRoleWorkspace = false;
    });
  }

  void _saveFunctionalRoles(List<FunctionalRole> roles) {
    widget.onFunctionalRolesChanged(roles);
    _closeFunctionalRoles();
  }

  @override
  Widget build(BuildContext context) {
    if (_showFunctionalRoleWorkspace) {
      return SizedBox.expand(
        child: FunctionalRoleAssignmentWorkspace(
          organizationId: widget.organizationId,
          canCreateRole: true,
          onCreateRole: _handleCreateFunctionalRole,
          initialSelectedRoles: widget.selectedFunctionalRoles,
          onCancel: _closeFunctionalRoles,
          onSave: _saveFunctionalRoles,
          embedded: true,
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 950),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Organizational Assignments',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F3A4A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connect this person to the parts of your '
                      'organization where they belong.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),

                    // Volunteer qualification summary.
                    if (widget.isVolunteer) ...[
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 760),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFEFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFA5F3FC)),
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.school_outlined,
                                  size: 22,
                                  color: Color(0xFF0891B2),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Volunteer Qualifications',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF164E63),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCFFAFE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${widget.credentials.length} '
                                '${widget.credentials.length == 1 ? 'Credential' : 'Credentials'} '
                                'Added',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0E7490),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Organizational assignments: responsive card layout.
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 700) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _AssignmentCard(
                          icon: Icons.groups_outlined,
                          title: 'Groups',
                          description:
                              'Assign this person to one or more '
                              'groups or teams.',
                        ),
                        const SizedBox(height: 16),
                        _AssignmentCard(
                          icon: Icons.location_on_outlined,
                          title: 'Locations',
                          description:
                              'Connect this person to one or more '
                              'locations.',
                        ),
                        const SizedBox(height: 16),
                        _AssignmentCard(
                          icon: Icons.badge_outlined,
                          title: 'Functional Roles',
                          description: 'Assign the roles this person performs.',
                          assignmentCount:
                              widget.selectedFunctionalRoles.length,
                          onAssign: _openFunctionalRoles,
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _AssignmentCard(
                          icon: Icons.groups_outlined,
                          title: 'Groups',
                          description:
                              'Assign this person to one or more '
                              'groups or teams.',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _AssignmentCard(
                          icon: Icons.location_on_outlined,
                          title: 'Locations',
                          description:
                              'Connect this person to one or more '
                              'locations.',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _AssignmentCard(
                          icon: Icons.badge_outlined,
                          title: 'Functional Roles',
                          description: 'Assign the roles this person performs.',
                          assignmentCount:
                              widget.selectedFunctionalRoles.length,
                          onAssign: _openFunctionalRoles,
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Volunteer qualifications are separate from
              // organizational assignments.
              if (widget.isVolunteer) ...[
                const SizedBox(height: 32),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 26,
                      color: Color(0xFF0891B2),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Volunteer Qualifications',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Track what this volunteer is qualified or cleared to do.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 18),
                CredentialsComplianceCard(
                  credentials: widget.credentials,
                  onChanged: widget.onCredentialsChanged,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreateFunctionalRole() {
    // Functional Role creation UI will be connected here.
  }
}

class _AssignmentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int assignmentCount;
  final VoidCallback? onAssign;

  const _AssignmentCard({
    required this.icon,
    required this.title,
    required this.description,
    this.assignmentCount = 0,
    this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    final hasAssignments = assignmentCount > 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E5EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: const Color(0xFF5B4BC4)),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2F3A4A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),
          if (hasAssignments) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$assignmentCount assigned',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5B4BC4),
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onAssign,
            icon: Icon(hasAssignments ? Icons.edit_outlined : Icons.add),
            label: Text(hasAssignments ? 'Edit' : 'Assign'),
          ),
        ],
      ),
    );
  }
}
