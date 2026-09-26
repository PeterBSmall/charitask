import 'package:flutter/material.dart';

import '../domain/models/group.dart';

class GroupTypeBadge extends StatelessWidget {
  final GroupType? type;

  const GroupTypeBadge({super.key, required this.type});

  static const _cyan = Color(0xFF06B6D4);
  static const _gray = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final groupType = type;

    if (groupType == null) {
      return _buildBadge(
        label: 'Group',
        icon: Icons.groups_outlined,
        foregroundColor: _gray,
        backgroundColor: const Color(0xFFF1F5F9),
      );
    }

    return _buildBadge(
      label: groupType.label,
      icon: _iconFor(groupType),
      foregroundColor: _cyan,
      backgroundColor: const Color(0xFFE6F9FC),
    );
  }

  Widget _buildBadge({
    required String label,
    required IconData icon,
    required Color foregroundColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(GroupType type) {
    switch (type) {
      case GroupType.team:
        return Icons.groups_outlined;
      case GroupType.committee:
        return Icons.account_balance_outlined;
      case GroupType.cohort:
        return Icons.diversity_3_outlined;
      case GroupType.participantGroup:
        return Icons.people_alt_outlined;
      case GroupType.leadershipTeam:
        return Icons.workspace_premium_outlined;
      case GroupType.staffGroup:
        return Icons.badge_outlined;
    }
  }
}
