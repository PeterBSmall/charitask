import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/foundations/app_colors.dart';
import 'package:charitask/shared/design_system/foundations/app_radius.dart';
import 'package:charitask/shared/design_system/foundations/app_shadows.dart';
import 'package:charitask/shared/design_system/foundations/app_spacing.dart';

class FoundationRecentActivity extends StatelessWidget {
  const FoundationRecentActivity({super.key});

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

          _buildActivityItem(
            icon: Icons.person_add_alt_1_outlined,
            iconColor: const Color(0xFF6F9366),
            title: 'New employee invited',
            description: 'Sarah Johnson was invited to join.',
            time: '2h ago',
          ),

          _buildTimelineLine(),

          _buildActivityItem(
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFFC8872E),
            title: 'Location added',
            description: 'Falmouth ReStore was added.',
            time: '5h ago',
          ),

          _buildTimelineLine(),

          _buildActivityItem(
            icon: Icons.dashboard_customize_outlined,
            iconColor: AppColors.missionPurple,
            title: 'Role updated',
            description: 'Manager role permissions updated.',
            time: '1d ago',
          ),

          _buildTimelineLine(),

          _buildActivityItem(
            icon: Icons.groups_outlined,
            iconColor: const Color(0xFF4F6FD6),
            title: 'Team created',
            description: 'Leadership Team was created.',
            time: '2d ago',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 280;

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('View All'),
              ),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F3A4A),
              ),
            ),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        );
      },
    );
  }

  Widget _buildTimelineLine() {
    return Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Container(width: 2, height: 20, color: const Color(0xFFE3E6EC)),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // During live window resizing Flutter can temporarily provide
        // unbounded width. Never use Expanded in that situation.
        if (!constraints.hasBoundedWidth) {
          return _buildUnboundedActivityItem(
            icon: icon,
            iconColor: iconColor,
            title: title,
            description: description,
            time: time,
          );
        }

        final isNarrow = constraints.maxWidth < 360;

        if (isNarrow) {
          return _buildNarrowActivityItem(
            icon: icon,
            iconColor: iconColor,
            title: title,
            description: description,
            time: time,
          );
        }

        return _buildWideActivityItem(
          icon: icon,
          iconColor: iconColor,
          title: title,
          description: description,
          time: time,
        );
      },
    );
  }

  Widget _buildWideActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF8B95A7),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F3A4A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Color(0xFF7B8494)),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Text(
          time,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7B8494)),
        ),
      ],
    );
  }

  Widget _buildNarrowActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF8B95A7),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F3A4A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Color(0xFF7B8494)),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(fontSize: 12, color: Color(0xFF7B8494)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnboundedActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF8B95A7),
              shape: BoxShape.circle,
            ),
          ),
        ),

        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F3A4A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 13, color: Color(0xFF7B8494)),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 12, color: Color(0xFF7B8494)),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildNarrowActivityItem({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String description,
  required String time,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 48,
        child: Column(
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF8B95A7),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),

      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F3A4A),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7B8494),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7B8494),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
