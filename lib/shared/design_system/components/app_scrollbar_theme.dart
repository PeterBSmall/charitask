import 'package:flutter/material.dart';

import '../foundations/app_colors.dart';

class AppScrollbarTheme {
  static ScrollbarThemeData get light {
    return ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      trackVisibility: WidgetStateProperty.all(true),

      thickness: WidgetStateProperty.resolveWith<double>((states) {
        return states.contains(WidgetState.hovered) ? 12 : 10;
      }),

      radius: const Radius.circular(100),

      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        return states.contains(WidgetState.hovered)
            ? AppColors.missionPurple.withValues(alpha: 0.75)
            : AppColors.missionPurple.withValues(alpha: 0.50);
      }),

      trackColor: WidgetStateProperty.all(
        AppColors.missionPurple.withValues(alpha: 0.06),
      ),

      interactive: true,
    );
  }
}
