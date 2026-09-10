import 'package:flutter/material.dart';

class WorkspaceDashboardConfig {
  final String workspaceLabel;
  final String greeting;
  final String headline;
  final String description;

  final Color accentColor;
  final List<Color> heroGradient;
  final IconData workspaceIcon;
  final String heroImagePath;

  final String inspirationImagePath;
  final String inspirationTitle;
  final String inspirationMessage;
  final String inspirationStat;

  final List<WorkspaceKpiConfig> kpis;

  const WorkspaceDashboardConfig({
    required this.workspaceLabel,
    required this.greeting,
    required this.headline,
    required this.description,
    required this.accentColor,
    required this.heroGradient,
    required this.workspaceIcon,
    required this.heroImagePath,
    required this.inspirationImagePath,
    required this.inspirationTitle,
    required this.inspirationMessage,
    required this.inspirationStat,
    required this.kpis,
  });
}

class WorkspaceKpiConfig {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const WorkspaceKpiConfig({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
