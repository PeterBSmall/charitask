import 'package:flutter/material.dart';

import '../../design_system/foundations/app_spacing.dart';
import '../../design_system/foundations/app_typography.dart';
import 'ct_card.dart';

class CTModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  // Optional icon styling.
  // Existing cards remain unchanged when these aren't provided.
  final Color? iconColor;
  final Color? iconBackground;

  const CTModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.iconColor,
    this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return CTCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 26, color: iconColor),
          ),

          const SizedBox(width: AppSpacing.lg),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.title),

                const SizedBox(height: AppSpacing.sm),

                Text(description, style: AppTypography.body),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
