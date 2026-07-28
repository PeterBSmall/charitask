import 'package:flutter/material.dart';

import '../foundations/app_colors.dart';

class AppSwitchTheme {
  AppSwitchTheme._();

  static SwitchThemeData get light {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }

        return Colors.white;
      }),

      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.missionPurple;
        }

        return AppColors.border;
      }),
    );
  }
}
