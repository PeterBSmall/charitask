import 'package:flutter/material.dart';

import 'package:charitask/shared/theme/app_colors.dart';
import 'package:charitask/shared/theme/app_radius.dart';
import 'package:charitask/shared/theme/app_shadows.dart';
import 'package:charitask/shared/theme/app_spacing.dart';
import 'package:charitask/shared/widgets/layout/ct_section_header.dart';

class CTWorkspacePanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const CTWorkspacePanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: CTSectionHeader(title: title, subtitle: subtitle),
          ),

          const Divider(height: 1),

          Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: child),
        ],
      ),
    );
  }
}
