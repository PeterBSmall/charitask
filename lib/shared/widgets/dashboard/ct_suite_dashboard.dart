import 'package:flutter/material.dart';

import '../../models/ct_suite_dashboard_config.dart';
import '../../theme/app_spacing.dart';
import '../layout/ct_section_header.dart';

class CTSuiteDashboard extends StatelessWidget {
  final CTSuiteDashboardConfig config;

  const CTSuiteDashboard({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Hero
        config.hero,

        const SizedBox(height: AppSpacing.xxxl),

        // Metrics
        config.metrics,

        const SizedBox(height: AppSpacing.xxxl),

        // Quick Actions
        CTSectionHeader(
          title: config.quickActionsTitle,
          subtitle: config.quickActionsSubtitle,
        ),

        const SizedBox(height: AppSpacing.lg),

        config.quickActions,

        const SizedBox(height: AppSpacing.xxxl),

        // Modules
        CTSectionHeader(
          title: config.modulesTitle,
          subtitle: config.modulesSubtitle,
        ),

        const SizedBox(height: AppSpacing.lg),

        config.modules,

        const SizedBox(height: AppSpacing.xxxl),

        // Activity
        CTSectionHeader(
          title: config.activityTitle,
          subtitle: config.activitySubtitle,
        ),

        const SizedBox(height: AppSpacing.lg),

        config.activity,

        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}
