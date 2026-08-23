import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/foundations/app_typography.dart';

class CTPlaceholderPage extends StatelessWidget {
  final String title;

  const CTPlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text('$title coming soon', style: AppTypography.title),
      ),
    );
  }
}
