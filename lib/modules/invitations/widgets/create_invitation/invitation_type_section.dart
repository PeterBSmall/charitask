import 'package:flutter/material.dart';

import '../../domain/models/create_invitation_draft.dart';
import '../../domain/models/invitation_type.dart';

class InvitationTypeSection extends StatelessWidget {
  const InvitationTypeSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  final CreateInvitationDraft draft;
  final ValueChanged<InvitationType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Invitation Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'What are you inviting this person to join?',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 560
                ? 2
                : 1;

            final spacing = 12.0;
            final cardWidth = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing * (columns - 1)) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: InvitationType.values.map((type) {
                return SizedBox(
                  width: cardWidth,
                  child: _InvitationTypeCard(
                    type: type,
                    selected: draft.invitationType == type,
                    onTap: () => onChanged(type),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _InvitationTypeCard extends StatelessWidget {
  const _InvitationTypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final InvitationType type;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (type) {
      case InvitationType.organization:
        return Icons.business_outlined;
      case InvitationType.workspace:
        return Icons.dashboard_outlined;
      case InvitationType.location:
        return Icons.location_on_outlined;
      case InvitationType.program:
        return Icons.account_tree_outlined;
      case InvitationType.group:
        return Icons.groups_outlined;
      case InvitationType.event:
        return Icons.event_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF7C3AED);
    const navy = Color(0xFF1E293B);
    const gray = Color(0xFF64748B);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? purple.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? purple : const Color(0xFFE2E8F0),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? purple.withValues(alpha: 0.12)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(_icon, size: 21, color: selected ? purple : gray),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            type.label,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: navy,
                            ),
                          ),
                        ),
                        if (selected)
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: purple,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type.description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: gray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
