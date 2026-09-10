import 'package:flutter/material.dart';

import '../models/workspace_dashboard_config.dart';

const volunteerCoordinatorDashboardConfig = WorkspaceDashboardConfig(
  workspaceLabel: 'VOLUNTEER COORDINATOR',
  greeting: 'Good morning, Peter!',
  headline: 'Your volunteer program is\nmaking a difference.',
  description:
      'Manage volunteers, fill shifts, track hours, and\nkeep your team engaged from one place.',
  accentColor: Color(0xFF2563EB),
  heroGradient: [Color(0xFF172554), Color(0xFF2563EB)],
  workspaceIcon: Icons.volunteer_activism_outlined,
  heroImagePath: 'assets/images/workspaces/volunteer_hero.png',

  inspirationImagePath: 'assets/images/workspaces/volunteer_together.png',

  inspirationTitle: 'Together',
  inspirationMessage: 'We create stronger communities.',
  inspirationStat: '142 Volunteers helped this month.',

  kpis: [
    WorkspaceKpiConfig(
      label: 'Active Volunteers',
      value: '142',
      icon: Icons.volunteer_activism_outlined,
      color: Color(0xFF2563EB),
    ),
    WorkspaceKpiConfig(
      label: 'Open Shifts',
      value: '18',
      icon: Icons.event_available_outlined,
      color: Color(0xFF2563EB),
    ),
    WorkspaceKpiConfig(
      label: 'Shift Coverage',
      value: '87%',
      icon: Icons.pie_chart_outline,
      color: Color(0xFF2563EB),
    ),
    WorkspaceKpiConfig(
      label: 'Upcoming Events',
      value: '6',
      icon: Icons.calendar_month_outlined,
      color: Color(0xFF2563EB),
    ),
  ],
);
