import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';
import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/foundations/app_radius.dart';
import 'package:charitask/shared/design_system/foundations/app_shadows.dart';

class CTMetricCard extends StatefulWidget {
  final CTMetric metric;
  final bool isSelected;
  final VoidCallback? onTap;

  const CTMetricCard({
    super.key,
    required this.metric,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<CTMetricCard> createState() => _CTMetricCardState();
}

class _CTMetricCardState extends State<CTMetricCard> {
  bool _isSelected = false;

  Color get _iconColor {
    switch (widget.metric.label) {
      case 'Org':
        return AppColors.missionPurple;

      case 'People':
        return const Color(0xFF5B8FD9);

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
        return const Color(0xFF5B4BC4);

      default:
        return AppColors.missionPurple;
    }
  }

  bool get _selected => _isSelected || widget.isSelected;

  void _handleTap() {
    setState(() {
      _isSelected = true;
    });

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final color = _iconColor;

    return AnimatedScale(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      scale: _selected ? 1.01 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: _selected
                  ? color.withValues(alpha: 0.10)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(
                color: _selected
                    ? color.withValues(alpha: 0.55)
                    : Colors.transparent,
                width: _selected ? 1.5 : 1,
              ),
              boxShadow: _selected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.16),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : AppShadows.small,
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: _selected ? 0.18 : 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.metric.icon, color: color, size: 27),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.metric.label == 'Org'
                            ? 'Org Profile'
                            : widget.metric.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _selected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: _selected ? color : const Color(0xFF2F3A4A),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        widget.metric.label == 'Org'
                            ? 'View & manage'
                            : widget.metric.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: _selected
                              ? color.withValues(alpha: 0.85)
                              : const Color(0xFF7B8494),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
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
