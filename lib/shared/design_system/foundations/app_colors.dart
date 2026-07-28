import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  //==========================================================
  // Brand Colors
  //==========================================================

  static const Color missionPurple = Color(0xFF6C4CF1);
  static const Color missionPurpleLight = Color(0xFF8B75FF);
  static const Color missionPurpleDark = Color(0xFF5133C9);

  // Suite Colors
  static const Color peopleBlue = Color(0xFF3B82F6);
  static const Color operationsGreen = Color(0xFF10B981);
  static const Color commerceOrange = Color(0xFFF59E0B);
  static const Color impactTeal = Color(0xFF14B8A6);

  //==========================================================
  // Surfaces
  //==========================================================

  static const Color background = Color(0xFFF8F9FC);
  static const Color surface = Colors.white;
  static const Color surfaceAlt = Color(0xFFF3F4F6);

  //==========================================================
  // Text
  //==========================================================

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  //==========================================================
  // Borders
  //==========================================================

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE7EAF2);

  //==========================================================
  // Status
  //==========================================================

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  //==========================================================
  // Material Color Scheme
  //==========================================================

  static final ColorScheme colorScheme = ColorScheme.light(
    primary: missionPurple,
    secondary: missionPurpleLight,

    surface: surface,

    error: error,

    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textPrimary,
    onError: Colors.white,
  );
}
