import 'package:flutter/material.dart';

import '../foundations/app_colors.dart';
import '../foundations/app_radius.dart';
import '../foundations/app_typography.dart';

class AppTextFieldTheme {
  AppTextFieldTheme._();

  static InputDecorationTheme get light {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,

      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),

      hintStyle: AppTypography.body.copyWith(color: AppColors.textMuted),

      labelStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: BorderSide(color: AppColors.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: BorderSide(color: AppColors.border),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: BorderSide(color: AppColors.missionPurple, width: 2),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: BorderSide(color: AppColors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
    );
  }
}
