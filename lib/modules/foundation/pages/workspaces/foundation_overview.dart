import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/organization/organization_workspace.dart';
import 'package:charitask/shared/models/ct_workspace_overview_config.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

String _foundationGreeting(String firstName) {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning, $firstName.';
  } else if (hour < 17) {
    return 'Good Afternoon, $firstName.';
  } else {
    return 'Good Evening, $firstName.';
  }
}

CTWorkspaceOverviewConfig foundationOverview(
  BuildContext context,
  CTJourneyController journeyController,
) {
  final organizationName = journeyController.organization.identity.name.trim();

  final firstName = journeyController.firstName.trim();

  return CTWorkspaceOverviewConfig(
    // Identity
    icon: Icons.account_balance_rounded,
    suiteName: 'Foundation',

    // Greeting
    greeting: _foundationGreeting(firstName.isEmpty ? 'there' : firstName),

    // Mission Hero
    mission: 'Your foundation is ready. Now let’s build what comes next.',
    welcomeMessage:
        'Build the structure that supports every mission, every person, and every opportunity to serve.',
    organizationName: organizationName.isEmpty
        ? 'Your Organization'
        : organizationName,

    // Progress
    progress: .75,
    nextStep: 'Finalize Your Organization Setup',

    // Actions
    primaryButtonLabel: 'Continue Setup',
    onPrimaryPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              OrganizationWorkspace(journeyController: journeyController),
        ),
      );
    },

    secondaryButtonLabel: 'View Organization',
    onSecondaryPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              OrganizationWorkspace(journeyController: journeyController),
        ),
      );
    },

    // Theme
    accentColor: AppColors.missionPurple,
    backgroundGradient: const [Color(0xFF6C4CF1), Color(0xFF7B5CFA)],
  );
}
