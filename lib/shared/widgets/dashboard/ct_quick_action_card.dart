import 'package:flutter/material.dart';

import '../../design_system/foundations/app_colors.dart';
import '../../design_system/foundations/app_radius.dart';
import '../../design_system/foundations/app_shadows.dart';
import '../../design_system/foundations/app_spacing.dart';
import '../../design_system/foundations/app_typography.dart';

class CTQuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isPrimary;

  const CTQuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary
        ? AppColors.missionPurple
        : AppColors.surface;

    final titleColor = isPrimary ? Colors.white : const Color(0xFF374151);

    final subtitleColor = isPrimary
        ? Colors.white.withValues(alpha: 0.80)
        : const Color(0xFF6B7280);

    final iconBackgroundColor = isPrimary
        ? Colors.white.withValues(alpha: 0.15)
        : AppColors.missionPurple.withValues(alpha: 0.12);

    final iconColor = isPrimary ? Colors.white : AppColors.missionPurple;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.large),
        onTap: onTap,
        child: Container(
          width: 190,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.large),
            boxShadow: AppShadows.small,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(icon, color: iconColor, size: 30),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.title.copyWith(color: titleColor),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(color: subtitleColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
