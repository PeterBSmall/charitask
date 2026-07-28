import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/foundations/app_radius.dart';
import 'package:charitask/shared/design_system/foundations/app_shadows.dart';
import 'package:charitask/shared/design_system/foundations/app_spacing.dart';
import 'package:charitask/shared/design_system/foundations/app_typography.dart';

class CTMetricCard extends StatelessWidget {
  final CTMetric metric;

  const CTMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.missionPurple.withOpacity(.12),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Icon(metric.icon, color: AppColors.missionPurple),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            metric.label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          Text(
            metric.label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
