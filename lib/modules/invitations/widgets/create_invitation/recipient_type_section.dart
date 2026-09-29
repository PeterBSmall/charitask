import 'package:flutter/material.dart';

import '../../domain/models/create_invitation_draft.dart';
import '../../domain/models/invitation_recipient_type.dart';

class RecipientTypeSection extends StatelessWidget {
  const RecipientTypeSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  final CreateInvitationDraft draft;
  final ValueChanged<InvitationRecipientType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recipient Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose whether you are inviting an existing person or someone new to ChariTask.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 650;
            final spacing = 12.0;
            final cardWidth = isWide
                ? (constraints.maxWidth - spacing) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: InvitationRecipientType.values.map((type) {
                return SizedBox(
                  width: cardWidth,
                  child: _RecipientTypeCard(
                    type: type,
                    selected: draft.recipientType == type,
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

class _RecipientTypeCard extends StatelessWidget {
  const _RecipientTypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final InvitationRecipientType type;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (type) {
      case InvitationRecipientType.existingPerson:
        return Icons.person_outline;
      case InvitationRecipientType.newPerson:
        return Icons.person_add_alt_outlined;
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
                            style: const TextStyle(
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
