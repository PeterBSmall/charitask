import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_workspace_overview_config.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';

final foundationOverview = CTWorkspaceOverviewConfig(
  // Identity
  icon: Icons.account_balance_rounded,
  suiteName: 'Foundation',

  // Mission Hero
  greeting: 'Good Morning, Peter.',

  mission: 'Organizations create possibility.',

  welcomeMessage:
      'Build the structure that supports every mission, every person, and every opportunity to serve.',

  organizationName: 'Habitat for Humanity of Cape Cod',

  // Progress
  progress: .72,
  nextStep: 'Complete Organization Setup',

  // Actions
  primaryButtonLabel: 'Continue Setup',
  onPrimaryPressed: () {},

  secondaryButtonLabel: 'View Organization',
  onSecondaryPressed: () {},

  // Theme
  accentColor: AppColors.missionPurple,

  backgroundGradient: const [Color(0xFF6C4CF1), Color(0xFF7B5CFA)],
);
