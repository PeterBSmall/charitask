import 'package:flutter/material.dart';

import 'groups_kpi_card.dart';

class GroupsKpiRow extends StatelessWidget {
  final int activeGroups;
  final int staffGroups;
  final int volunteerGroups;
  final int programGroups;
  final double averageMembers;

  const GroupsKpiRow({
    super.key,
    required this.activeGroups,
    required this.staffGroups,
    required this.volunteerGroups,
    required this.programGroups,
    required this.averageMembers,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 950;

        if (compact) {
          return _buildCompact();
        }

        return Row(
          children: [
            Expanded(
              child: GroupsKpiCard(
                label: 'Active Groups',
                value: activeGroups.toString(),
                icon: Icons.groups_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GroupsKpiCard(
                label: 'Staff Groups',
                value: staffGroups.toString(),
                icon: Icons.badge_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GroupsKpiCard(
                label: 'Volunteer Groups',
                value: volunteerGroups.toString(),
                icon: Icons.volunteer_activism_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GroupsKpiCard(
                label: 'Program Groups',
                value: programGroups.toString(),
                icon: Icons.account_tree_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GroupsKpiCard(
                label: 'Average Members',
                value: averageMembers.toStringAsFixed(1),
                icon: Icons.people_outline,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompact() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(
          width: 210,
          child: GroupsKpiCard(
            label: 'Active Groups',
            value: activeGroups.toString(),
            icon: Icons.groups_outlined,
          ),
        ),
        SizedBox(
          width: 210,
          child: GroupsKpiCard(
            label: 'Staff Groups',
            value: staffGroups.toString(),
            icon: Icons.badge_outlined,
          ),
        ),
        SizedBox(
          width: 210,
          child: GroupsKpiCard(
            label: 'Volunteer Groups',
            value: volunteerGroups.toString(),
            icon: Icons.volunteer_activism_outlined,
          ),
        ),
        SizedBox(
          width: 210,
          child: GroupsKpiCard(
            label: 'Program Groups',
            value: programGroups.toString(),
            icon: Icons.account_tree_outlined,
          ),
        ),
        SizedBox(
          width: 210,
          child: GroupsKpiCard(
            label: 'Average Members',
            value: averageMembers.toStringAsFixed(1),
            icon: Icons.people_outline,
          ),
        ),
      ],
    );
  }
}
