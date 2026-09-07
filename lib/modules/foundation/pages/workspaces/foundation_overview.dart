import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_workspace_overview_config.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

CTWorkspaceOverviewConfig foundationOverview(
  BuildContext context,
  CTJourneyController journeyController,
) {
  return CTWorkspaceOverviewConfig(
    // Identity
    icon: Icons.account_balance_rounded,
    suiteName: 'Foundation',

    // Hero label
    greeting: 'Foundation',

    // Completed workspace hero
    welcomeMessage: 'Peter, your organization is active and running smoothly.',

    organizationName:
        'You’ve built a strong foundation. Now you can manage people, '
        'locations, and teams—all in one place.',

    mission: '',

    // Setup is complete.
    progress: null,
    nextStep: null,

    // No hero action.
    primaryButtonLabel: '',
    onPrimaryPressed: () {},

    // No secondary action.
    secondaryButtonLabel: null,
    onSecondaryPressed: null,

    // Theme
    accentColor: AppColors.missionPurple,
    backgroundGradient: const [Color(0xFF4338B8), Color(0xFF5B4BC4)],
  );
}
