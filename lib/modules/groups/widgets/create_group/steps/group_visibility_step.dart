import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/create_group_draft.dart';
import 'package:charitask/modules/groups/domain/models/group.dart';

class GroupPermissionsStep extends StatelessWidget {
  const GroupPermissionsStep({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  final CreateGroupDraft draft;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Group Visibility',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose how this group appears in your organization.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        RadioGroup<GroupVisibility>(
          groupValue: draft.visibility,
          onChanged: (value) {
            if (value != null) {
              draft.visibility = value;
              onChanged();
            }
          },
          child: Column(
            children: [
              _visibilityOption(
                title: 'Public',
                description: 'Visible in the organization’s group listings.',
                value: GroupVisibility.public,
              ),
              _visibilityOption(
                title: 'Private',
                description:
                    'Not displayed in public group listings. Access remains governed by existing permissions.',
                value: GroupVisibility.private,
              ),
              _visibilityOption(
                title: 'Hidden',
                description: 'Excluded from standard group listings.',
                value: GroupVisibility.hidden,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _visibilityOption({
    required String title,
    required String description,
    required GroupVisibility value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: RadioListTile<GroupVisibility>(
        value: value,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        activeColor: const Color(0xFF06B6D4),
      ),
    );
  }
}
