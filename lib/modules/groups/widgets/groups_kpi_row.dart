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
        final width = constraints.maxWidth;

        final columns = width >= 950
            ? 5
            : width >= 700
            ? 3
            : width >= 460
            ? 2
            : 1;

        const spacing = 12.0;
        final totalSpacing = spacing * (columns - 1);
        final cardWidth = (width - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: GroupsKpiCard(
                label: 'Active Groups',
                value: activeGroups.toString(),
                icon: Icons.groups_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: GroupsKpiCard(
                label: 'Staff Groups',
                value: staffGroups.toString(),
                icon: Icons.badge_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: GroupsKpiCard(
                label: 'Volunteer Groups',
                value: volunteerGroups.toString(),
                icon: Icons.volunteer_activism_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: GroupsKpiCard(
                label: 'Program Groups',
                value: programGroups.toString(),
                icon: Icons.account_tree_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
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
}
