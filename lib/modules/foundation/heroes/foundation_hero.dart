import 'package:flutter/material.dart';

import '../../../shared/design_system/foundations/app_colors.dart';
import '../../../shared/widgets/dashboard/ct_workspace_hero.dart';

class FoundationHero extends StatelessWidget {
  const FoundationHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const CTWorkspaceHero(
      greeting: 'Welcome back.',

      title: 'Foundation',

      subtitle:
          'Build the structure that supports every mission, every person, and every opportunity to serve.',

      tagline: 'Organizations create possibility.',

      nextStep: 'Complete Organization Setup',

      progress: .72,

      icon: Icons.account_balance_rounded,

      accentColor: AppColors.missionPurple,
    );
  }
}
