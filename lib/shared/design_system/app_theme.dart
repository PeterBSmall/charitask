import 'package:flutter/material.dart';

import 'components/app_button_theme.dart';
import 'components/app_checkbox_theme.dart';
import 'foundations/app_colors.dart';
import 'components/app_scrollbar_theme.dart';
import 'components/app_slider_theme.dart';
import 'components/app_textfield_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      //======================================================
      // Foundation
      //======================================================
      colorScheme: AppColors.colorScheme,

      //======================================================
      // Components
      //======================================================
      elevatedButtonTheme: AppButtonTheme.elevated,
      outlinedButtonTheme: AppButtonTheme.outlined,
      textButtonTheme: AppButtonTheme.text,

      inputDecorationTheme: AppTextFieldTheme.light,

      sliderTheme: AppSliderTheme.light,

      checkboxTheme: AppCheckboxTheme.light,

      scrollbarTheme: AppScrollbarTheme.light,
    );
  }
}
