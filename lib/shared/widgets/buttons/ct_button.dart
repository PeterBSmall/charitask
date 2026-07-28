import 'package:flutter/material.dart';

import '../../design_system/foundations/app_colors.dart';
import '../../design_system/foundations/app_radius.dart';
import '../../design_system/foundations/app_spacing.dart';

class CTButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const CTButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isPrimary
            ? Colors.white
            : Colors.white.withOpacity(.12),
        foregroundColor: isPrimary ? AppColors.missionPurple : Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
      ),
      child: Text(label),
    );
  }
}
