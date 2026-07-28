import 'package:flutter/material.dart';

import '../foundations/app_colors.dart';

class AppCheckboxTheme {
  AppCheckboxTheme._();

  static CheckboxThemeData get light {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),

      side: const BorderSide(color: AppColors.border, width: 1.5),

      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.missionPurple;
        }

        return Colors.white;
      }),

      checkColor: WidgetStateProperty.all(Colors.white),
    );
  }
}
