import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_workspace_overview_config.dart';
import 'package:charitask/shared/theme/app_colors.dart';

final foundationOverview = CTWorkspaceOverviewConfig(
  // Identity
  icon: Icons.account_balance,
  suiteName: 'Foundation',

  // Greeting
  greeting: 'Good Morning, Peter.',

  welcomeMessage: 'Let\'s continue strengthening your organization.',

  organizationName: 'Habitat for Humanity of Cape Cod',

  mission: 'Organizations create possibility.',

  // Progress
  progress: .72,
  nextStep: 'Continue Setup → Complete Locations',

  // Actions
  primaryButtonLabel: 'Continue Setup',
  onPrimaryPressed: () {},

  secondaryButtonLabel: 'View Organization',
  onSecondaryPressed: () {},

  // Theme
  accentColor: AppColors.missionPurple,

  backgroundGradient: const [Color(0xFF6C4CF1), Color(0xFF7B5CFA)],
);
