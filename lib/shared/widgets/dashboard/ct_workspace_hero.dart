import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

class CTWorkspaceHero extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Widget? action;

  const CTWorkspaceHero({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accentColor, accentColor.withOpacity(.82)],
        ),
        boxShadow: AppShadows.large,
      ),
      child: Row(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 42, color: Colors.white),
          ),

          const SizedBox(width: AppSpacing.xl),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.display.copyWith(color: Colors.white),
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  subtitle,
                  style: AppTypography.body.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),

          if (action != null) action!,
        ],
      ),
    );
  }
}
