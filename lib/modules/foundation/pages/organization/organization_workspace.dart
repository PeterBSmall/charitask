import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/foundations/app_spacing.dart';
import 'package:charitask/shared/widgets/cards/ct_module_card.dart';
import 'package:charitask/shared/widgets/layout/ct_page.dart';

class OrganizationWorkspace extends StatelessWidget {
  const OrganizationWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return CTPage(
      title: 'Organization',
      subtitle: 'Define your organization’s identity, mission, and brand.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CTModuleCard(
            icon: Icons.flag,
            title: 'Mission Profile',
            description:
                'Organization name, logo, mission statement and history',
            onTap: () {},
          ),

          const SizedBox(height: AppSpacing.lg),

          CTModuleCard(
            icon: Icons.favorite,
            title: 'Mission Engine',
            description:
                'Vision, values, mission moments and organizational culture',
            onTap: () {},
          ),

          const SizedBox(height: AppSpacing.lg),

          CTModuleCard(
            icon: Icons.palette,
            title: 'Brand Identity',
            description: 'Colors, typography, logos and brand assets',
            onTap: () {},
          ),

          const SizedBox(height: AppSpacing.lg),

          CTModuleCard(
            icon: Icons.contact_phone,
            title: 'Contact Information',
            description: 'Website, email, phone and social media',
            onTap: () {},
          ),

          const SizedBox(height: AppSpacing.lg),

          CTModuleCard(
            icon: Icons.account_balance,
            title: 'Legal & Compliance',
            description: 'Registration, governance and compliance information',
            onTap: () {},
          ),

          const SizedBox(height: AppSpacing.lg),

          CTModuleCard(
            icon: Icons.folder,
            title: 'Resources',
            description:
                'Policies, handbooks, templates and organization resources',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
