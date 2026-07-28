import 'package:flutter/material.dart';

import '../foundations/app_colors.dart';

class AppSliderTheme {
  AppSliderTheme._();

  static SliderThemeData get light {
    return SliderThemeData(
      trackHeight: 4,

      activeTrackColor: AppColors.missionPurple,

      inactiveTrackColor: AppColors.border,

      thumbColor: AppColors.missionPurpleLight,

      overlayColor: AppColors.missionPurple.withValues(alpha: .18),

      valueIndicatorColor: AppColors.missionPurple,

      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),

      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),

      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
