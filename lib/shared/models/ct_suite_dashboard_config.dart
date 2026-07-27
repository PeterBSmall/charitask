import 'package:flutter/material.dart';

class CTSuiteDashboardConfig {
  /// Workspace Sections
  final Widget hero;
  final Widget metrics;

  /// Main Workspace Content
  final Widget primaryContent;
  final Widget secondaryContent;

  /// Activity
  final Widget activity;

  /// Primary Section
  final String primaryTitle;
  final String primarySubtitle;

  /// Secondary Section
  final String secondaryTitle;
  final String secondarySubtitle;

  /// Activity Section
  final String activityTitle;
  final String activitySubtitle;

  const CTSuiteDashboardConfig({
    required this.hero,
    required this.metrics,

    required this.primaryContent,
    required this.secondaryContent,

    required this.activity,

    this.primaryTitle = 'Primary',
    this.primarySubtitle = '',

    this.secondaryTitle = 'Secondary',
    this.secondarySubtitle = '',

    this.activityTitle = 'Recent Activity',
    this.activitySubtitle = 'Latest updates across this suite.',
  });
}
