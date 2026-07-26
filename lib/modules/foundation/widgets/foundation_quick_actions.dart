import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/dashboard/ct_quick_action_card.dart';

class FoundationQuickActions extends StatelessWidget {
  const FoundationQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        CTQuickActionCard(
          icon: Icons.person_add,
          title: 'Add Person',
          subtitle: 'Create an employee or volunteer',
          onTap: () {},
        ),

        CTQuickActionCard(
          icon: Icons.location_city,
          title: 'Add Location',
          subtitle: 'Add a campus or office',
          onTap: () {},
        ),

        CTQuickActionCard(
          icon: Icons.group_add,
          title: 'Create Group',
          subtitle: 'Departments and teams',
          onTap: () {},
        ),

        CTQuickActionCard(
          icon: Icons.settings,
          title: 'Settings',
          subtitle: 'Configure Foundation',
          onTap: () {},
        ),
      ],
    );
  }
}
