import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/organization/organization_workspace.dart';
import 'package:charitask/modules/foundation/widgets/foundation_active_tasks.dart';
import 'package:charitask/modules/foundation/widgets/foundation_hero.dart';
import 'package:charitask/modules/foundation/widgets/foundation_pinned_notes.dart';
import 'package:charitask/modules/foundation/widgets/foundation_recent_activity.dart';
import 'package:charitask/modules/foundation/widgets/foundation_workspace_shell.dart';
import 'package:charitask/modules/people/pages/people_page.dart';

import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/models/ct_metric.dart';
import 'package:charitask/shared/widgets/dashboard/index.dart';
import 'package:charitask/shared/widgets/workspace/ct_workspace_metrics.dart';
import 'package:charitask/modules/workspaces/templates/pages/workspace_template_selection_page.dart';

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

// ============================================================================
// FOUNDATION DASHBOARD
// ============================================================================

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
            // ----------------------------------------------------------------
            // HERO
            // ----------------------------------------------------------------
            FoundationHero(journeyController: widget.journeyController),

            const SizedBox(height: 16),

            // ----------------------------------------------------------------
            // QUICK ACCESS CARDS
            // ----------------------------------------------------------------
            CTWorkspaceMetrics(
              metrics: const [
                CTMetric(
                  icon: Icons.account_balance_outlined,
                  value: 'View & manage',
                  label: 'Org',
                ),
                CTMetric(
                  icon: Icons.people_outline,
                  value: '148 Members',
                  label: 'People',
                ),
                CTMetric(
                  icon: Icons.groups_outlined,
                  value: '12 Teams',
                  label: 'Groups',
                ),
                CTMetric(
                  icon: Icons.location_on_outlined,
                  value: '4 Active',
                  label: 'Locations',
                ),
                CTMetric(
                  icon: Icons.dashboard_customize_outlined,
                  value: '7 Modules',
                  label: 'Suites',
                ),
                CTMetric(
                  icon: Icons.task_alt_outlined,
                  value: '18 Pending',
                  label: 'Tasks',
                ),
                CTMetric(
                  icon: Icons.notifications_none_outlined,
                  value: '3 Critical',
                  label: 'Alerts',
                ),
                CTMetric(
                  icon: Icons.campaign_outlined,
                  value: '5 Channels',
                  label: 'Communications',
                ),
              ],

              onMetricSelected: (metric) {
                switch (metric.label) {
                  case 'Org':
                    // Organization
                    widget.onNavigate(1);
                    break;

                  case 'People':
                    // People
                    widget.onNavigate(2);
                    break;

                  case 'Groups':
                    // Groups
                    widget.onNavigate(3);
                    break;

                  case 'Locations':
                    // Locations will be connected when that page is ready.
                    break;

                  case 'Suites':
                    // Suites will be connected when the module system is ready.
                    break;

                  case 'Tasks':
                    // Tasks will be connected when the task workspace is ready.
                    break;

                  case 'Alerts':
                    // Alerts will be connected when the alert center is ready.
                    break;

                  case 'Communications':
                    // Communications will be connected when the communications workspace is ready.
                    break;
                }
              },
            ),
            const SizedBox(height: 24),

            // ----------------------------------------------------------------
            // DASHBOARD PANELS
            // ----------------------------------------------------------------
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

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

                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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

// ============================================================================
// PLACEHOLDER PAGE
// ============================================================================

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
