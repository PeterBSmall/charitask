import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/people_access_person.dart';

import '../../domain/models/create_invitation_draft.dart';
import '../../domain/models/invitation_delivery_method.dart';
import '../../domain/models/invitation_recipient_type.dart';
import '../../domain/models/invitation_type.dart';
import 'delivery_method_section.dart';
import 'invitation_type_section.dart';
import 'recipient_selection_section.dart';
import 'recipient_type_section.dart';

class ConfigureInvitationStep extends StatelessWidget {
  const ConfigureInvitationStep({
    super.key,
    required this.organizationId,
    required this.draft,
    required this.onInvitationTypeChanged,
    required this.onRecipientTypeChanged,
    required this.onExistingPeopleChanged,
    required this.onAddNewPerson,
    required this.onDeliveryMethodChanged,
  });

  final String organizationId;
  final CreateInvitationDraft draft;
  final ValueChanged<InvitationType> onInvitationTypeChanged;
  final ValueChanged<InvitationRecipientType> onRecipientTypeChanged;
  final ValueChanged<List<PeopleAccessPerson>> onExistingPeopleChanged;
  final Future<void> Function() onAddNewPerson;
  final ValueChanged<InvitationDeliveryMethod> onDeliveryMethodChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1050;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildMainContent()),
              const SizedBox(width: 24),
              SizedBox(width: 300, child: InvitationSummary(draft: draft)),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainContent(),
            const SizedBox(height: 20),
            InvitationSummary(draft: draft),
          ],
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InvitationTypeSection(draft: draft, onChanged: onInvitationTypeChanged),
        const SizedBox(height: 24),
        RecipientTypeSection(draft: draft, onChanged: onRecipientTypeChanged),
        const SizedBox(height: 24),
        RecipientSelectionSection(
          organizationId: organizationId,
          draft: draft,
          onExistingPeopleChanged: onExistingPeopleChanged,
          onAddNewPerson: onAddNewPerson,
        ),
        const SizedBox(height: 24),
        DeliveryMethodSection(draft: draft, onChanged: onDeliveryMethodChanged),
      ],
    );
  }
}

class InvitationSummary extends StatelessWidget {
  const InvitationSummary({super.key, required this.draft});

  final CreateInvitationDraft draft;

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF7C3AED);
    const navy = Color(0xFF1E293B);
    const gray = Color(0xFF64748B);

    final recipientCount = draft.recipientIds.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.summarize_outlined, size: 20, color: purple),
              SizedBox(width: 8),
              Text(
                'Invitation Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SummaryItem(
            label: 'Invitation Type',
            value: draft.invitationType?.label ?? 'Not selected',
          ),
          _SummaryItem(
            label: 'Recipients',
            value: recipientCount == 0
                ? 'None selected'
                : '$recipientCount selected',
          ),
          _SummaryItem(
            label: 'Delivery Method',
            value: draft.deliveryMethod?.label ?? 'Not selected',
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: draft.isComplete
                  ? const Color(0xFFECFDF5)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  draft.isComplete
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  size: 18,
                  color: draft.isComplete ? const Color(0xFF059669) : gray,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    draft.isComplete
                        ? 'Ready for Next Step'
                        : 'Complete the required selections to continue.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: draft.isComplete ? const Color(0xFF047857) : gray,
                    ),
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

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
