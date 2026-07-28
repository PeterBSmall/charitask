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

  const CTQuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.large),
        onTap: onTap,
        child: Container(
          width: 190,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
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
                  color: AppColors.missionPurple.withOpacity(.12),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Icon(icon, color: AppColors.missionPurple, size: 30),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.title,
              ),

              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
