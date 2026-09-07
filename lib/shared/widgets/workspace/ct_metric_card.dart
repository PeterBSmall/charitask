import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/foundations/app_radius.dart';
import 'package:charitask/shared/design_system/foundations/app_shadows.dart';

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
        return const Color(0xFF6F9366);

      case 'Locations':
        return const Color(0xFFC8872E);

      case 'Suites':
        return const Color(0xFF5B4BC4);

      case 'Tasks':
        return const Color(0xFF6F9366);

      case 'Alerts':
        return const Color(0xFFC65A4A);

      case 'Communications':
        return const Color(0xFF6B5DD3);

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

            // Compact dashboard card height.
            height: 80,

            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

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

            child: Row(
              children: [
                // Icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.26)
                        : color.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(metric.icon, color: color, size: 21),
                ),

                const SizedBox(width: 12),

                // Text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        metric.label == 'Org' ? 'Org Profile' : metric.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: isSelected ? color : const Color(0xFF2F3A4A),
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        metric.label == 'Org' ? 'View & manage' : metric.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: isSelected ? color : const Color(0xFF7B8494),
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // Arrow
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: color.withValues(alpha: 0.85),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
