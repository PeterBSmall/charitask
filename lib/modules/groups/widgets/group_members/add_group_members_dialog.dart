import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/people_access_person.dart';
import 'package:charitask/modules/people/widgets/people_access/people_access_picker.dart';

class AddGroupMembersDialog extends StatefulWidget {
  final String organizationId;
  final Set<String> excludedPersonIds;

  const AddGroupMembersDialog({
    super.key,
    required this.organizationId,
    required this.excludedPersonIds,
  });

  @override
  State<AddGroupMembersDialog> createState() => _AddGroupMembersDialogState();
}

class _AddGroupMembersDialogState extends State<AddGroupMembersDialog> {
  static const _purple = Color(0xFF7C3AED);

  static const _border = Color(0xFFE2E8F0);

  static const Map<String, String> _roles = {
    'leader': 'Leader',
    'co_leader': 'Co-Leader',
    'coordinator': 'Coordinator',
    'member': 'Member',
  };

  final List<PeopleAccessPerson> _selectedPeople = [];
  final Map<String, String> _memberRoles = {};

  void _handlePeopleChanged(List<PeopleAccessPerson> people) {
    final selectedIds = people.map((person) => person.id).toSet();

    setState(() {
      _selectedPeople
        ..clear()
        ..addAll(people);

      _memberRoles.removeWhere(
        (personId, _) => !selectedIds.contains(personId),
      );

      for (final person in people) {
        _memberRoles.putIfAbsent(person.id, () => 'member');
      }
    });
  }

  Widget _buildRoleSelector(PeopleAccessPerson person) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            person.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _memberRoles[person.id] ?? 'member',
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Group Membership Role',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: _roles.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                _memberRoles[person.id] = value;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return AlertDialog(
      title: const Text('Add Members'),
      content: SizedBox(
        width: screenSize.width < 720 ? screenSize.width * 0.84 : 620,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenSize.height * 0.68),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PeopleAccessPicker(
                  organizationId: widget.organizationId,
                  excludedPersonIds: widget.excludedPersonIds,
                  title: 'Select People',
                  subtitle: 'Choose people to add to this group.',
                  onChanged: _handlePeopleChanged,
                ),
                if (_selectedPeople.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Assign Group Membership Roles',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._selectedPeople.map(_buildRoleSelector),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedPeople.isEmpty
              ? null
              : () {
                  Navigator.of(
                    context,
                  ).pop(Map<String, String>.from(_memberRoles));
                },
          style: FilledButton.styleFrom(
            backgroundColor: _purple,
            foregroundColor: Colors.white,
          ),
          child: Text('Add Members (${_selectedPeople.length})'),
        ),
      ],
    );
  }
}
