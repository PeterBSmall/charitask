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
import 'package:charitask/modules/people/pages/people_page.dart';

class FoundationWorkspacePage extends StatelessWidget {
  final CTJourneyController journeyController;

  const FoundationWorkspacePage({super.key, required this.journeyController});

  @override
  Widget build(BuildContext context) {
    return FoundationWorkspaceShell(
      dashboardBuilder: (onNavigate) => FoundationDashboard(
        journeyController: journeyController,
        onNavigate: onNavigate,
      ),

      organization: OrganizationWorkspace(journeyController: journeyController),

      people: const PeoplePage(),

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
  final ValueChanged<int> onNavigate;

  const FoundationDashboard({
    super.key,
    required this.journeyController,
    required this.onNavigate,
  });

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
          12,
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

            const SizedBox(height: 4),

            FoundationHero(journeyController: widget.journeyController),

            const SizedBox(height: 16),

            CTWorkspaceMetrics(
              metrics: foundationMetrics,
              onMetricSelected: (index) {
                if (index == 1) {
                  widget.onNavigate(2);
                }
              },
            ),

            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                // Large desktop:
                // Three equal cards matching the reference design.
                if (width >= 1100) {
                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: FoundationActiveTasks()),

                      SizedBox(width: 24),

                      Expanded(child: FoundationRecentActivity()),

                      SizedBox(width: 24),

                      Expanded(child: FoundationPinnedNotes()),
                    ],
                  );
                }

                // Medium width:
                // Two columns, with the actual available width calculated
                // instead of using a fixed card width.
                if (width >= 700) {
                  final cardWidth = (width - 24) / 2;

                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: const FoundationActiveTasks(),
                      ),

                      SizedBox(
                        width: cardWidth,
                        child: const FoundationRecentActivity(),
                      ),

                      SizedBox(
                        width: cardWidth,
                        child: const FoundationPinnedNotes(),
                      ),
                    ],
                  );
                }

                // Narrow:
                // One full-width card at a time.
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FoundationActiveTasks(),

                    SizedBox(height: 24),

                    FoundationRecentActivity(),

                    SizedBox(height: 24),

                    FoundationPinnedNotes(),
                  ],
                );
              },
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
