import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_workspace_overview_config.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

String _foundationGreeting(String firstName) {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Welcome back, $firstName! 🎉';
  } else if (hour < 17) {
    return 'Welcome back, $firstName! 🎉';
  } else {
    return 'Welcome back, $firstName! 🎉';
  }
}

CTWorkspaceOverviewConfig foundationOverview(
  BuildContext context,
  CTJourneyController journeyController,
) {
  final firstName = journeyController.firstName.trim();

  return CTWorkspaceOverviewConfig(
    // Identity
    icon: Icons.account_balance_rounded,
    suiteName: 'Foundation',

    // Greeting
    greeting: _foundationGreeting(firstName.isEmpty ? 'there' : firstName),

    // Completed workspace hero
    welcomeMessage: 'Your organization is active and running smoothly.',

    organizationName:
        'You’ve built a strong foundation. Now you can manage people, '
        'locations, and teams—all in one place.',

    mission: '',

    // Setup is complete.
    progress: null,
    nextStep: null,

    // Completed workspace action
    primaryButtonLabel: 'View Reports',
    onPrimaryPressed: () {
      // Reports will be connected when Analytics is ready.
    },

    // No secondary action.
    secondaryButtonLabel: null,
    onSecondaryPressed: null,

    // Theme
    accentColor: AppColors.missionPurple,
    backgroundGradient: const [Color(0xFF4338B8), Color(0xFF5B4BC4)],
  );
}
