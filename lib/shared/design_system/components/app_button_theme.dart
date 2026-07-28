import 'package:flutter/material.dart';

import '../foundations/app_colors.dart';
import '../foundations/app_radius.dart';
import '../foundations/app_typography.dart';

class AppButtonTheme {
  AppButtonTheme._();

  static ElevatedButtonThemeData get elevated {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.missionPurple,
        foregroundColor: Colors.white,

        elevation: 0,

        minimumSize: const Size(140, 48),

        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),

        textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  static OutlinedButtonThemeData get outlined {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.missionPurple,

        minimumSize: const Size(140, 48),

        side: BorderSide(color: AppColors.missionPurple.withValues(alpha: .25)),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),

        textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextButtonThemeData get text {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.missionPurple,

        textStyle: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
