import 'package:flutter/material.dart';

import '../../models/ct_suite_dashboard_config.dart';
import '../../design_system/foundations/app_spacing.dart';
import '../layout/ct_section_header.dart';
import 'package:charitask/shared/widgets/workspace/ct_workspace_panel.dart';

class CTSuiteDashboard extends StatelessWidget {
  final CTSuiteDashboardConfig config;

  const CTSuiteDashboard({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      child: ListView(
        controller: controller,
        children: [
          // Hero
          config.hero,

          const SizedBox(height: AppSpacing.xl),

          // Metrics
          config.metrics,

          const SizedBox(height: AppSpacing.xxl),

          // Workspace Columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CTWorkspacePanel(
                  title: config.primaryTitle,
                  subtitle: config.primarySubtitle,
                  child: config.primaryContent,
                ),
              ),

              const SizedBox(width: AppSpacing.xl),

              Expanded(
                child: CTWorkspacePanel(
                  title: config.secondaryTitle,
                  subtitle: config.secondarySubtitle,
                  child: config.secondaryContent,
                ),
              ),
            ],
          ),

          // Activity
          CTSectionHeader(
            title: config.activityTitle,
            subtitle: config.activitySubtitle,
          ),

          const SizedBox(height: AppSpacing.lg),

          config.activity,

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
