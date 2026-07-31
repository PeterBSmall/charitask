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
              width: 340,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NEXT STEP',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white70,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    nextStep!,
                    style: AppTypography.titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text(
                    'Locations are the foundation for assigning people, volunteers, schedules, and resources.',
                    style: AppTypography.body.copyWith(
                      color: Colors.white70,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Row(
                    children: [
                      const Icon(
                        Icons.schedule,
                        color: Colors.white70,
                        size: 18,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        'Estimated time • 2 minutes',
                        style: AppTypography.body.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Continue Setup'),
                    ),
                  ),

                  if (progress != null) ...[
                    const SizedBox(height: AppSpacing.xl),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
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
