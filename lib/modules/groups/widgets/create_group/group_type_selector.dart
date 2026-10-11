import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/create_group_draft.dart';

class GroupTypeSelector extends StatelessWidget {
  final CreateGroupDraft draft;
  final VoidCallback? onChanged;

  const GroupTypeSelector({super.key, required this.draft, this.onChanged});

  static const _options = [
    CreateGroupTypeOption.team,
    CreateGroupTypeOption.committee,
    CreateGroupTypeOption.department,
    CreateGroupTypeOption.cohort,
    CreateGroupTypeOption.participantGroup,
    CreateGroupTypeOption.leadershipTeam,
    CreateGroupTypeOption.staffGroup,
    CreateGroupTypeOption.volunteerGroup,
    CreateGroupTypeOption.board,
    CreateGroupTypeOption.donorCircle,
    CreateGroupTypeOption.ministry,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760
            ? 4
            : constraints.maxWidth >= 500
            ? 2
            : 1;

        const spacing = 12.0;

        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: _options.map((option) {
            return SizedBox(width: width, child: _buildCard(option));
          }).toList(),
        );
      },
    );
  }

  Widget _buildCard(CreateGroupTypeOption option) {
    final selected = draft.groupTypeOption == option;

    return InkWell(
      onTap: () {
        draft.setGroupType(option);
        onChanged?.call();
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFECFEFF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF06B6D4) : const Color(0xFFE2E8F0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _iconFor(option),
              color: selected
                  ? const Color(0xFF0891B2)
                  : const Color(0xFF64748B),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _labelFor(option),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: Color(0xFF06B6D4),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(CreateGroupTypeOption option) {
    switch (option) {
      case CreateGroupTypeOption.team:
        return Icons.groups_rounded;
      case CreateGroupTypeOption.committee:
        return Icons.account_balance_rounded;
      case CreateGroupTypeOption.department:
        return Icons.business_center_rounded;
      case CreateGroupTypeOption.cohort:
        return Icons.diversity_3_rounded;
      case CreateGroupTypeOption.participantGroup:
        return Icons.people_alt_rounded;
      case CreateGroupTypeOption.leadershipTeam:
        return Icons.workspace_premium_rounded;
      case CreateGroupTypeOption.staffGroup:
        return Icons.badge_rounded;
      case CreateGroupTypeOption.volunteerGroup:
        return Icons.volunteer_activism_rounded;
      case CreateGroupTypeOption.board:
        return Icons.account_balance_rounded;
      case CreateGroupTypeOption.donorCircle:
        return Icons.favorite_rounded;
      case CreateGroupTypeOption.ministry:
        return Icons.church_rounded;
    }
  }

  String _labelFor(CreateGroupTypeOption option) {
    switch (option) {
      case CreateGroupTypeOption.team:
        return 'Team';
      case CreateGroupTypeOption.committee:
        return 'Committee';
      case CreateGroupTypeOption.department:
        return 'Department';
      case CreateGroupTypeOption.cohort:
        return 'Cohort';
      case CreateGroupTypeOption.participantGroup:
        return 'Participant Group';
      case CreateGroupTypeOption.leadershipTeam:
        return 'Leadership Team';
      case CreateGroupTypeOption.staffGroup:
        return 'Staff Group';
      case CreateGroupTypeOption.volunteerGroup:
        return 'Volunteer Group';
      case CreateGroupTypeOption.board:
        return 'Board';
      case CreateGroupTypeOption.donorCircle:
        return 'Donor Circle';
      case CreateGroupTypeOption.ministry:
        return 'Ministry';
    }
  }
}
