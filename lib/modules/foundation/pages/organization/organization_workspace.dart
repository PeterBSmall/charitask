import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/foundations/app_spacing.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/widgets/cards/ct_module_card.dart';
import 'package:charitask/shared/widgets/layout/ct_page.dart';
import 'package:charitask/shared/widgets/workspace/ct_workspace_sidebar.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';

class OrganizationWorkspace extends StatelessWidget {
  final CTJourneyController journeyController;

  const OrganizationWorkspace({super.key, required this.journeyController});

  @override
  Widget build(BuildContext context) {
    final organizationName = journeyController.organization.identity.name
        .trim();

    return CTPage(
      title: organizationName.isEmpty ? 'Organization' : organizationName,
      subtitle: 'Define your organization’s identity, mission, and brand.',
      scrollable: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ------------------------------------------------------------
          // ORGANIZATION SIDEBAR
          // ------------------------------------------------------------
          CTWorkspaceSidebar(
            workspaceName: organizationName.isEmpty
                ? 'Organization'
                : organizationName,
            selectedItem: 'Overview',
            items: [
              CTWorkspaceSidebarItem(
                label: 'Overview',
                icon: Icons.dashboard_outlined,
                iconColor: AppColors.missionPurple,
                onTap: () {},
              ),
              CTWorkspaceSidebarItem(
                label: 'Organization Profile',
                icon: Icons.flag_outlined,
                iconColor: const Color(0xFF67B96B),
                onTap: () {},
              ),
              CTWorkspaceSidebarItem(
                label: 'Mission Engine',
                icon: Icons.favorite_outline,
                iconColor: const Color(0xFF7657D9),
                onTap: () {},
              ),
              CTWorkspaceSidebarItem(
                label: 'Brand Identity',
                icon: Icons.palette_outlined,
                iconColor: const Color(0xFFD9B43B),
                onTap: () {},
              ),
              CTWorkspaceSidebarItem(
                label: 'Contact Information',
                icon: Icons.contact_phone_outlined,
                iconColor: const Color(0xFFE77A2F),
                onTap: () {},
              ),
              CTWorkspaceSidebarItem(
                label: 'Legal & Compliance',
                icon: Icons.account_balance_outlined,
                iconColor: const Color(0xFF4D9C98),
                onTap: () {},
              ),
              CTWorkspaceSidebarItem(
                label: 'Resources',
                icon: Icons.folder_outlined,
                iconColor: const Color(0xFF5B7FEA),
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(width: AppSpacing.lg),

          // ------------------------------------------------------------
          // ORGANIZATION OVERVIEW
          // ------------------------------------------------------------
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CTModuleCard(
                    icon: Icons.flag_outlined,
                    title: 'Organization Profile',
                    description:
                        'Organization name, logo, mission statement and history',
                    iconColor: const Color(0xFF67B96B),
                    iconBackground: const Color(0xFFEAF6EC),
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  CTModuleCard(
                    icon: Icons.favorite_outline,
                    title: 'Mission Engine',
                    description:
                        'Vision, values, mission moments and organizational culture',
                    iconColor: const Color(0xFF7657D9),
                    iconBackground: const Color(0xFFF0ECFF),
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  CTModuleCard(
                    icon: Icons.palette_outlined,
                    title: 'Brand Identity',
                    description: 'Colors, typography, logos and brand assets',
                    iconColor: const Color(0xFFD9B43B),
                    iconBackground: const Color(0xFFFBF5DF),
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  CTModuleCard(
                    icon: Icons.contact_phone_outlined,
                    title: 'Contact Information',
                    description: 'Website, email, phone and social media',
                    iconColor: const Color(0xFFE77A2F),
                    iconBackground: const Color(0xFFFDF0E7),
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  CTModuleCard(
                    icon: Icons.account_balance_outlined,
                    title: 'Legal & Compliance',
                    description:
                        'Registration, governance and compliance information',
                    iconColor: const Color(0xFF4D9C98),
                    iconBackground: const Color(0xFFEAF5F4),
                    onTap: () {},
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  CTModuleCard(
                    icon: Icons.folder_outlined,
                    title: 'Resources',
                    description:
                        'Policies, handbooks, templates and organization resources',
                    iconColor: const Color(0xFF5B7FEA),
                    iconBackground: const Color(0xFFEDF1FF),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
