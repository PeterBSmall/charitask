import 'package:flutter/material.dart';

import 'package:charitask/shared/workspaces/models/ct_workspace.dart';

import '../data/volunteer_coordinator_dashboard.dart';
import '../models/workspace_dashboard_config.dart';

import '../widgets/workspace_dashboard_hero.dart';
import '../widgets/workspace_inspiration_card.dart';
import '../widgets/workspace_kpi_row.dart';
import '../widgets/workspace_essentials.dart';
import '../widgets/workspace_at_a_glance.dart';
import '../widgets/workspace_health_card.dart';
import '../widgets/workspace_activity.dart';
import '../widgets/workspace_messaging.dart';

class WorkspaceDashboardPage extends StatelessWidget {
  final CTWorkspace workspace;

  const WorkspaceDashboardPage({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    final config = volunteerCoordinatorDashboardConfig;

    return Container(
      color: const Color(0xFFF7F8FC),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 1000;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              isCompact ? 16 : 28,
              14,
              isCompact ? 16 : 28,
              28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: isCompact
                    ? _buildCompactLayout(config)
                    : _buildDesktopLayout(config),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktopLayout(WorkspaceDashboardConfig config) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======================================================
        // LEFT / MAIN COLUMN
        // ======================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HERO
              WorkspaceDashboardHero(config: config),

              const SizedBox(height: 16),

              // KPI ROW
              WorkspaceKpiRow(config: config),

              const SizedBox(height: 20),

              // THE ESSENTIALS
              WorkspaceEssentials(accentColor: config.accentColor),

              const SizedBox(height: 16),

              // WORKSPACE AT A GLANCE
              WorkspaceAtAGlance(accentColor: config.accentColor),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // ======================================================
        // RIGHT COLUMN
        // ======================================================
        SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TOGETHER
              WorkspaceInspirationCard(config: config),

              const SizedBox(height: 16),

              // WORKSPACE HEALTH
              WorkspaceHealthCard(config: config),

              const SizedBox(height: 16),

              // RECENT ACTIVITY
              WorkspaceActivity(config: config),

              const SizedBox(height: 16),

              // INTERNAL MESSAGING
              WorkspaceMessaging(config: config),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // COMPACT
  // ============================================================

  Widget _buildCompactLayout(WorkspaceDashboardConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // HERO
        WorkspaceDashboardHero(config: config),

        const SizedBox(height: 16),

        // TOGETHER
        WorkspaceInspirationCard(config: config),

        const SizedBox(height: 16),

        // KPIs
        WorkspaceKpiRow(config: config),

        const SizedBox(height: 20),

        // ESSENTIALS
        WorkspaceEssentials(accentColor: config.accentColor),

        const SizedBox(height: 16),

        // HEALTH
        WorkspaceHealthCard(config: config),

        const SizedBox(height: 16),

        // ACTIVITY
        WorkspaceActivity(config: config),

        const SizedBox(height: 16),

        // MESSAGING
        WorkspaceMessaging(config: config),

        const SizedBox(height: 16),

        // AT A GLANCE
        WorkspaceAtAGlance(accentColor: config.accentColor),
      ],
    );
  }
}
