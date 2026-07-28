import 'package:flutter/material.dart';

import '../../design_system/foundations/app_colors.dart';
import '../../design_system/foundations/app_radius.dart';
import '../../design_system/foundations/app_shadows.dart';
import '../../design_system/foundations/app_spacing.dart';
import '../../design_system/foundations/app_typography.dart';

class CTWorkspaceHero extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Widget? action;

  // Mission Hero fields
  final String? greeting;
  final String? tagline;
  final String? nextStep;
  final double? progress;

  const CTWorkspaceHero({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.action,
    this.greeting,
    this.tagline,
    this.nextStep,
    this.progress,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.10),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(.15)),
            ),
            child: Icon(icon, size: 44, color: Colors.white),
          ),

          const SizedBox(width: AppSpacing.xxl),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (greeting != null) ...[
                  Text(
                    greeting!,
                    style: AppTypography.caption.copyWith(
                      color: Colors.white70,
                      letterSpacing: .4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 18, color: Colors.white70),

                        const SizedBox(width: 8),

                        Text(
                          'FOUNDATION',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white70,
                            letterSpacing: 2.4,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      tagline ?? title,
                      style: AppTypography.display.copyWith(
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                Text(
                  subtitle,
                  style: AppTypography.body.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),

          if (nextStep != null)
            SizedBox(
              width: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next Step',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    subtitle,
                    style: AppTypography.body.copyWith(color: Colors.white70),
                  ),
                  Text(
                    nextStep!,
                    style: AppTypography.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  if (progress != null) ...[
                    const SizedBox(height: AppSpacing.md),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            )
          else if (action != null)
            action!,
        ],
      ),
    );
  }
}
