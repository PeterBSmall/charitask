import 'package:flutter/material.dart';

/// Shared sizing used by every onboarding screen.
class CTOnboardingSpacing {
  const CTOnboardingSpacing._();

  static const EdgeInsets cardPadding = EdgeInsets.fromLTRB(56, 42, 56, 56);

  static const double progressToHeader = 20;
  static const double headerToField = 20;
  static const double fieldToButton = 18;

  static const double badgeSpacing = 20;
  static const double questionSpacing = 10;
}

class CTOnboardingSizes {
  const CTOnboardingSizes._();

  static const double cardRadius = 28;

  static const double badgeSize = 64;

  static const double buttonHeight = 60;

  static const double textFieldRadius = 18;
}

class CTOnboardingColors {
  const CTOnboardingColors._();

  static const purple = Color(0xFF6C4CF5);

  static const text = Color(0xFF1F2937);

  static const subtitle = Color(0xFF7C8596);

  static const border = Color(0xFFE5E7EB);

  static const badgeBackground = Color(0xFFF5F1FF);

  static const badgeBorder = Color(0xFFE5DDFF);
}
