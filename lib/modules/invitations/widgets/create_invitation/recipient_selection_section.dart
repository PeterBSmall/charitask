import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/people_access_person.dart';
import 'package:charitask/modules/people/widgets/people_access/people_access_picker.dart';

import '../../domain/models/create_invitation_draft.dart';
import '../../domain/models/invitation_recipient_type.dart';

class RecipientSelectionSection extends StatelessWidget {
  const RecipientSelectionSection({
    super.key,
    required this.organizationId,
    required this.draft,
    required this.onExistingPeopleChanged,
    required this.onAddNewPerson,
  });

  final String organizationId;
  final CreateInvitationDraft draft;
  final ValueChanged<List<PeopleAccessPerson>> onExistingPeopleChanged;
  final Future<void> Function() onAddNewPerson;

  @override
  Widget build(BuildContext context) {
    final recipientType = draft.recipientType;

    if (recipientType == null) {
      return const _RecipientSelectionPlaceholder();
    }

    switch (recipientType) {
      case InvitationRecipientType.existingPerson:
        return PeopleAccessPicker(
          organizationId: organizationId,
          title: 'Select People',
          subtitle:
              'Search for people in your organization who should receive this invitation.',
          onChanged: onExistingPeopleChanged,
          onAddNewPerson: onAddNewPerson,
        );

      case InvitationRecipientType.newPerson:
        return _NewPersonSection(onAddNewPerson: onAddNewPerson);
    }
  }
}

class _RecipientSelectionPlaceholder extends StatelessWidget {
  const _RecipientSelectionPlaceholder();

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.person_search_outlined,
      title: 'Select a Recipient Type',
      message: 'Choose Existing Person or New Person above.',
    );
  }
}

class _NewPersonSection extends StatelessWidget {
  const _NewPersonSection({required this.onAddNewPerson});

  final Future<void> Function() onAddNewPerson;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.person_add_alt_outlined,
      title: 'New Person',
      message:
          'Enter the new person’s information to create an invitation for someone who does not yet have a ChariTask account.',
      action: OutlinedButton.icon(
        onPressed: onAddNewPerson,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add New Person'),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF7C3AED)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF64748B),
                  ),
                ),
                if (action != null) ...[const SizedBox(height: 14), action!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
