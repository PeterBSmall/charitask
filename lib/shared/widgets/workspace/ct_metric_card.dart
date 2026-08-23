import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/foundations/app_radius.dart';
import 'package:charitask/shared/design_system/foundations/app_shadows.dart';
import 'package:charitask/shared/design_system/foundations/app_spacing.dart';

class CTMetricCard extends StatelessWidget {
  final CTMetric metric;
  final bool isSelected;
  final VoidCallback? onTap;

  const CTMetricCard({
    super.key,
    required this.metric,
    this.isSelected = false,
    this.onTap,
  });

  Color get _iconColor {
    switch (metric.label) {
      case 'Org':
        return AppColors.missionPurple;

      case 'People':
        return const Color(0xFF4F6FD6);

      case 'Groups':
        return const Color(0xFF5B6472);

      case 'Locations':
        return const Color(0xFFC8872E);

      case 'Suites':
        return const Color(0xFF5B4BC4);

      case 'Tasks':
        return const Color(0xFF6F9366);

      case 'Alerts':
        return const Color(0xFFC65A4A);

      default:
        return AppColors.missionPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _iconColor;

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      scale: isSelected ? 1.02 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: 145,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.08)
                  : AppColors.surface,

              borderRadius: BorderRadius.circular(AppRadius.large),

              border: Border.all(
                color: isSelected
                    ? color.withValues(alpha: 0.50)
                    : Colors.transparent,
                width: isSelected ? 1.5 : 1,
              ),

              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.14),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : AppShadows.small,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.26)
                        : color.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(metric.icon, color: color, size: 24),
                ),

                const SizedBox(height: 12),

                // Main category
                Text(
                  metric.label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? color : const Color(0xFF2F3A4A),
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 5),

                // Detail / count
                Text(
                  metric.value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected ? color : const Color(0xFF7B8494),
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
