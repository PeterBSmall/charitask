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
      scale: isSelected ? 1.02 : 1.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 112,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.06)
                : AppColors.surface,

            borderRadius: BorderRadius.circular(AppRadius.large),

            border: Border.all(
              color: isSelected
                  ? color.withValues(alpha: 0.45)
                  : Colors.transparent,
              width: isSelected ? 1.5 : 1,
            ),

            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : AppShadows.small,
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.16)
                      : color.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(metric.icon, color: color, size: 21),
              ),

              const SizedBox(height: 7),

              Text(
                metric.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 3),

              Text(
                metric.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? color : const Color(0xFF7B8494),
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
