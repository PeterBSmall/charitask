import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';
import 'package:charitask/shared/theme/app_colors.dart';
import 'package:charitask/shared/theme/app_radius.dart';
import 'package:charitask/shared/theme/app_shadows.dart';
import 'package:charitask/shared/theme/app_spacing.dart';
import 'package:charitask/shared/theme/app_typography.dart';

class CTMetricCard extends StatelessWidget {
  final CTMetric metric;

  const CTMetricCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.small,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.missionPurple.withOpacity(.10),
            child: Icon(metric.icon, color: AppColors.missionPurple),
          ),

          const SizedBox(width: AppSpacing.lg),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(metric.value, style: AppTypography.headline),

                const SizedBox(height: 4),

                Text(metric.label, style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
