import 'package:flutter/material.dart';

import '../../domain/models/create_invitation_draft.dart';
import '../../domain/models/invitation_delivery_method.dart';

class DeliveryMethodSection extends StatelessWidget {
  const DeliveryMethodSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  final CreateInvitationDraft draft;
  final ValueChanged<InvitationDeliveryMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose how the invitation should be delivered.',
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

            const spacing = 12.0;

            final cardWidth = columns == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - spacing * (columns - 1)) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: InvitationDeliveryMethod.values.map((method) {
                return SizedBox(
                  width: cardWidth,
                  child: _DeliveryMethodCard(
                    method: method,
                    selected: draft.deliveryMethod == method,
                    onTap: () => onChanged(method),
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

class _DeliveryMethodCard extends StatelessWidget {
  const _DeliveryMethodCard({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final InvitationDeliveryMethod method;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (method) {
      case InvitationDeliveryMethod.email:
        return Icons.email_outlined;
      case InvitationDeliveryMethod.textMessage:
        return Icons.sms_outlined;
      case InvitationDeliveryMethod.emailAndText:
        return Icons.mark_email_unread_outlined;
      case InvitationDeliveryMethod.invitationLink:
        return Icons.link_outlined;
      case InvitationDeliveryMethod.qrCode:
        return Icons.qr_code_2_outlined;
    }
  }

  String get _description {
    switch (method) {
      case InvitationDeliveryMethod.email:
        return 'Send the invitation directly by email.';
      case InvitationDeliveryMethod.textMessage:
        return 'Send the invitation by text message.';
      case InvitationDeliveryMethod.emailAndText:
        return 'Deliver the invitation by both email and text.';
      case InvitationDeliveryMethod.invitationLink:
        return 'Create a shareable invitation link.';
      case InvitationDeliveryMethod.qrCode:
        return 'Create a QR code for the invitation.';
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
                            method.label,
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
                      _description,
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
