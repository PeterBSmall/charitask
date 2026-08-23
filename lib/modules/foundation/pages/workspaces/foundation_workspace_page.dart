import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/organization/organization_workspace.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_metrics_data.dart';
import 'package:charitask/modules/foundation/widgets/foundation_hero.dart';
import 'package:charitask/modules/foundation/widgets/foundation_workspace_shell.dart';

import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/widgets/workspace/ct_workspace_metrics.dart';
import 'package:charitask/modules/foundation/widgets/foundation_active_tasks.dart';
import 'package:charitask/modules/foundation/widgets/foundation_recent_activity.dart';
import 'package:charitask/modules/foundation/widgets/foundation_pinned_notes.dart';

class FoundationWorkspacePage extends StatelessWidget {
  final CTJourneyController journeyController;

  const FoundationWorkspacePage({super.key, required this.journeyController});

  @override
  Widget build(BuildContext context) {
    return FoundationWorkspaceShell(
      dashboard: FoundationDashboard(journeyController: journeyController),

      organization: OrganizationWorkspace(journeyController: journeyController),

      people: const _FoundationPlaceholderPage(
        title: 'People',
        subtitle: 'Manage the people connected to your organization.',
        icon: Icons.people_outline,
      ),

      groups: const _FoundationPlaceholderPage(
        title: 'Groups',
        subtitle: 'Organize people into teams, groups, and communities.',
        icon: Icons.groups_outlined,
      ),

      security: const _FoundationPlaceholderPage(
        title: 'Security',
        subtitle: 'Manage access, permissions, and security settings.',
        icon: Icons.shield_outlined,
      ),

      analytics: const _FoundationPlaceholderPage(
        title: 'Analytics',
        subtitle: 'Understand your organization and its activity.',
        icon: Icons.bar_chart_outlined,
      ),

      notes: const _FoundationPlaceholderPage(
        title: 'Notes',
        subtitle: 'Capture important information for your organization.',
        icon: Icons.sticky_note_2_outlined,
      ),
    );
  }
}

class FoundationDashboard extends StatefulWidget {
  final CTJourneyController journeyController;

  const FoundationDashboard({super.key, required this.journeyController});

  @override
  State<FoundationDashboard> createState() => _FoundationDashboardState();
}

class _FoundationDashboardState extends State<FoundationDashboard> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FC),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          24,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Foundation',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F3A4A),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Build the structure that supports your organization.',
              style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
            ),

            FoundationHero(journeyController: widget.journeyController),

            const SizedBox(height: 16),

            CTWorkspaceMetrics(metrics: foundationMetrics),

            const SizedBox(height: 24),

            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: FoundationActiveTasks()),

                SizedBox(width: 24),

                Expanded(child: FoundationRecentActivity()),

                SizedBox(width: 24),

                Expanded(child: FoundationPinnedNotes()),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _FoundationPlaceholderPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _FoundationPlaceholderPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FC),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: const Color(0xFF5B4BC4)),
            const SizedBox(height: AppSpacing.md),
            Text('$title coming soon', style: AppTypography.display),
          ],
        ),
      ),
    );
  }
}
