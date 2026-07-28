import 'package:flutter/material.dart';

import '../../design_system/foundations/app_colors.dart';
import '../../design_system/foundations/app_spacing.dart';
import '../../design_system/foundations/app_typography.dart';

class CTWorkspaceTaskTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String category;
  final Color color;
  final VoidCallback? onTap;

  const CTWorkspaceTaskTile({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(.12),
              child: Icon(icon, color: color, size: 20),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.body),

                  const SizedBox(height: 2),

                  Text(category, style: AppTypography.caption),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
