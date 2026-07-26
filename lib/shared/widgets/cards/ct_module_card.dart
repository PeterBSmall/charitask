import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'ct_card.dart';

class CTModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const CTModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CTCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 40),

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
