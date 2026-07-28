import 'package:flutter/material.dart';

import '../../design_system/foundations/app_colors.dart';
import '../../design_system/foundations/app_radius.dart';
import '../../design_system/foundations/app_shadows.dart';
import '../../design_system/foundations/app_spacing.dart';
import '../../design_system/foundations/app_typography.dart';

class CTWorkspaceSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final Widget child;

  const CTWorkspaceSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.small,
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.headline),

                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),

                      Text(subtitle!, style: AppTypography.caption),
                    ],
                  ],
                ),
              ),

              if (actionLabel != null)
                TextButton(
                  onPressed: onActionPressed,
                  child: Text(actionLabel!),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          child,
        ],
      ),
    );
  }
}
