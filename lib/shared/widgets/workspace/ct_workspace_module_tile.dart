import 'package:flutter/material.dart';

import '../../design_system/foundations/app_colors.dart';
import '../../design_system/foundations/app_radius.dart';
import '../../design_system/foundations/app_shadows.dart';
import '../../design_system/foundations/app_spacing.dart';
import '../../design_system/foundations/app_typography.dart';
import '../../design_system/foundations/app_motion.dart';
import '../../design_system/foundations/app_curves.dart';

class CTWorkspaceModuleTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final Color color;
  final VoidCallback? onTap;

  const CTWorkspaceModuleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
    this.onTap,
  });

  @override
  State<CTWorkspaceModuleTile> createState() => _CTWorkspaceModuleTileState();
}

class _CTWorkspaceModuleTileState extends State<CTWorkspaceModuleTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedSlide(
        duration: AppMotion.fast,
        curve: AppCurves.standard,
        offset: _hovering ? const Offset(0, -.015) : Offset.zero,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.large),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.large),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: AppMotion.fast,
              curve: AppCurves.standard,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.large),

                border: Border.all(
                  color: _hovering
                      ? AppColors.missionPurple
                      : const Color(0xFFE7EAF2),
                  width: 1.2,
                ),

                boxShadow: _hovering ? AppShadows.medium : AppShadows.small,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedScale(
                        duration: AppMotion.fast,
                        scale: _hovering ? 1.05 : 1,
                        child: AnimatedContainer(
                          duration: AppMotion.fast,
                          curve: AppCurves.standard,
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color.withValues(
                              alpha: _hovering ? .18 : .12,
                            ),
                          ),
                          child: AnimatedScale(
                            duration: AppMotion.fast,
                            curve: AppCurves.standard,
                            scale: _hovering ? 1.08 : 1.0,
                            child: Icon(
                              widget.icon,
                              color: widget.color,
                              size: 24,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: AppSpacing.md),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: AppTypography.body.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                                color: const Color(0xFF5F687A),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              widget.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    '${(widget.progress * 100).round()}% Complete',
                    style: AppTypography.caption,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: widget.progress,
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(widget.color),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  const Divider(height: 1),

                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Text(
                        'Open',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.missionPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      AnimatedSlide(
                        duration: AppMotion.fast,

                        offset: _hovering ? const Offset(.25, 0) : Offset.zero,
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.missionPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
