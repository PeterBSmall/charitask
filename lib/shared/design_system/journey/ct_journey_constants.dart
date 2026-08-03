import 'package:flutter/material.dart';

/// Shared sizing used by every Journey screen.
class CTJourneySpacing {
  const CTJourneySpacing._();

  static const EdgeInsets cardPadding = EdgeInsets.fromLTRB(56, 42, 56, 56);

  static const double progressToHeader = 20;
  static const double headerToField = 20;
  static const double fieldToButton = 18;

  static const double badgeSpacing = 20;
  static const double questionSpacing = 10;
}

class CTJourneySizes {
  const CTJourneySizes._();

  static const double cardRadius = 28;

  static const double badgeSize = 64;

  static const double buttonHeight = 58;

  static const double buttonRadius = 16;

  static const double textFieldRadius = 18;
}

class CTJourneyColors {
  const CTJourneyColors._();

  static const Color purple = Color(0xFF6C4CF5);

  static const Color title = Color(0xFF1F2937);
  static const Color body = Color(0xFF374151);
  static const Color subtitle = Color(0xFF7C8596);

  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE5E7EB);

  static const Color badgeBackground = Color(0xFFF5F1FF);
  static const Color badgeBorder = Color(0xFFE5DDFF);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
}
