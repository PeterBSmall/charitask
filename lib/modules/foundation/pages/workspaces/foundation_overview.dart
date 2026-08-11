import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/organization/organization_workspace.dart';
import 'package:charitask/shared/models/ct_workspace_overview_config.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';

String _foundationGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning, Peter.';
  } else if (hour < 17) {
    return 'Good Afternoon, Peter.';
  } else {
    return 'Good Evening, Peter.';
  }
}

CTWorkspaceOverviewConfig foundationOverview(BuildContext context) {
  return CTWorkspaceOverviewConfig(
    // Identity
    icon: Icons.account_balance_rounded,
    suiteName: 'Foundation',

    // Greeting
    greeting: _foundationGreeting(),

    // Mission Hero
    mission: 'Your foundation is ready. Now let’s build what comes next.',
    welcomeMessage:
        'Build the structure that supports every mission, every person, and every opportunity to serve.',
    organizationName: 'Habitat for Humanity of Cape Cod',

    // Progress
    progress: .75,
    nextStep: 'Finalize Your Organization Setup',

    // Actions
    primaryButtonLabel: 'Continue Setup',
    onPrimaryPressed: () {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const OrganizationWorkspace()));
    },

    secondaryButtonLabel: 'View Organization',
    onSecondaryPressed: () {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const OrganizationWorkspace()));
    },

    // Theme
    accentColor: AppColors.missionPurple,
    backgroundGradient: const [Color(0xFF6C4CF1), Color(0xFF7B5CFA)],
  );
}
