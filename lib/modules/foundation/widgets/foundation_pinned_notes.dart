import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/foundations/app_radius.dart';
import 'package:charitask/shared/design_system/foundations/app_shadows.dart';
import 'package:charitask/shared/design_system/foundations/app_spacing.dart';

class FoundationPinnedNotes extends StatelessWidget {
  const FoundationPinnedNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 260),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.large),
        boxShadow: AppShadows.small,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 20),

          _buildNote(
            icon: Icons.push_pin_outlined,
            title: 'Welcome to Foundation',
            description:
                'Your organization workspace is ready to start building.',
          ),

          const SizedBox(height: 16),

          _buildNote(
            icon: Icons.lightbulb_outline_rounded,
            title: 'Getting Started',
            description:
                'Complete your organization details to unlock more features.',
          ),

          const SizedBox(height: 16),

          _buildNote(
            icon: Icons.edit_note_outlined,
            title: 'Add a Note',
            description: 'Keep important information visible to your team.',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Pinned Notes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F3A4A),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded),
          tooltip: 'Add note',
          color: AppColors.missionPurple,
        ),
      ],
    );
  }

  Widget _buildNote({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.missionPurple.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.missionPurple),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2F3A4A),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Color(0xFF7B8494),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
