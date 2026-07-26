import 'package:flutter/material.dart';

import 'package:charitask/shared/theme/app_colors.dart';
import 'package:charitask/shared/widgets/dashboard/ct_workspace_hero.dart';

class FoundationHero extends StatelessWidget {
  const FoundationHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const CTWorkspaceHero(
      title: 'Foundation',
      subtitle:
          'Build the organizational foundation that powers every workspace.',
      icon: Icons.account_balance,
      accentColor: AppColors.missionPurple,
    );
  }
}
