import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/create_group_draft.dart';
import 'package:charitask/modules/groups/domain/models/group.dart';

class GroupVisibilitySelector extends StatelessWidget {
  final CreateGroupDraft draft;
  final VoidCallback? onChanged;

  const GroupVisibilitySelector({
    super.key,
    required this.draft,
    this.onChanged,
  });

  static const _options = [
    GroupVisibility.public,
    GroupVisibility.private,
    GroupVisibility.hidden,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760
            ? 3
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
          children: _options.map((visibility) {
            return SizedBox(width: width, child: _buildCard(visibility));
          }).toList(),
        );
      },
    );
  }

  Widget _buildCard(GroupVisibility visibility) {
    final selected = draft.visibility == visibility;

    return InkWell(
      onTap: () {
        draft.visibility = visibility;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              _iconFor(visibility),
              color: selected
                  ? const Color(0xFF0891B2)
                  : const Color(0xFF64748B),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visibility.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _descriptionFor(visibility),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.35,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle_rounded,
                size: 18,
                color: Color(0xFF06B6D4),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _iconFor(GroupVisibility visibility) {
    switch (visibility) {
      case GroupVisibility.public:
        return Icons.public_rounded;
      case GroupVisibility.private:
        return Icons.lock_outline_rounded;
      case GroupVisibility.hidden:
        return Icons.visibility_off_outlined;
    }
  }

  String _descriptionFor(GroupVisibility visibility) {
    switch (visibility) {
      case GroupVisibility.public:
        return 'Visible to people who can access the organization.';
      case GroupVisibility.private:
        return 'Visible only to people with access to this group.';
      case GroupVisibility.hidden:
        return 'Not shown in normal group listings or discovery.';
    }
  }
}
