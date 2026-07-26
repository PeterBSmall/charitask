import 'package:flutter/material.dart';

class CTWorkspaceOverviewConfig {
  /// Identity
  final IconData icon;
  final String suiteName;

  /// Greeting
  final String greeting;
  final String organizationName;
  final String mission;

  /// Welcome message
  final String welcomeMessage;

  /// Progress
  final String nextStep;

  /// Progress
  final double progress;

  /// Actions
  final String primaryButtonLabel;
  final VoidCallback? onPrimaryPressed;

  final String secondaryButtonLabel;
  final VoidCallback? onSecondaryPressed;

  /// Theme
  final Color accentColor;
  final List<Color> backgroundGradient;

  const CTWorkspaceOverviewConfig({
    required this.icon,
    required this.suiteName,
    required this.greeting,
    required this.organizationName,
    required this.mission,
    required this.progress,

    required this.primaryButtonLabel,
    required this.onPrimaryPressed,

    required this.secondaryButtonLabel,
    required this.onSecondaryPressed,

    required this.accentColor,
    required this.backgroundGradient,

    required this.welcomeMessage,
    required this.nextStep,
  });
}
