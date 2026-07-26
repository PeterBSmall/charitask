import 'package:flutter/material.dart';

class CTSuiteDashboardConfig {
  /// Dashboard Sections
  final Widget hero;
  final Widget metrics;
  final Widget quickActions;
  final Widget modules;
  final Widget activity;

  /// Section Titles
  final String quickActionsTitle;
  final String quickActionsSubtitle;

  final String modulesTitle;
  final String modulesSubtitle;

  final String activityTitle;
  final String activitySubtitle;

  const CTSuiteDashboardConfig({
    required this.hero,
    required this.metrics,
    required this.quickActions,
    required this.modules,
    required this.activity,

    this.quickActionsTitle = 'Quick Actions',
    this.quickActionsSubtitle = 'Common tasks to help you get started.',

    required this.modulesTitle,
    required this.modulesSubtitle,

    this.activityTitle = 'Recent Activity',
    this.activitySubtitle = 'Latest updates across this suite.',
  });
}
