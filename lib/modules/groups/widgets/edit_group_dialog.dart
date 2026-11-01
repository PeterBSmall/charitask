import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/group.dart';
import 'package:charitask/modules/groups/widgets/create_group/steps/group_owner_location_field.dart';

class GroupEditData {
  final String name;
  final String description;
  final GroupType groupType;
  final GroupVisibility visibility;
  final GroupOwnerType ownerType;
  final String? ownerId;
  final String? locationId;

  const GroupEditData({
    required this.name,
    required this.description,
    required this.groupType,
    required this.visibility,
    required this.ownerType,
    required this.ownerId,
    required this.locationId,
  });
}

class EditGroupDialog extends StatefulWidget {
  final Group group;

  const EditGroupDialog({super.key, required this.group});

  @override
  State<EditGroupDialog> createState() => _EditGroupDialogState();
}

class _EditGroupDialogState extends State<EditGroupDialog> {
  static const _cyan = Color(0xFF06B6D4);
  static const _purple = Color(0xFF7C3AED);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  late GroupType _groupType;
  late GroupVisibility _visibility;
  late GroupOwnerType? _ownerType;
  late String? _ownerId;

  String? _ownerError;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.group.name);

    _descriptionController = TextEditingController(
      text: widget.group.description ?? '',
    );

    _groupType = widget.group.groupType ?? GroupType.team;
    _visibility = widget.group.visibility;
    _ownerType = widget.group.ownerType;

    // Preserve the existing owner. Fall back to location_id for
    // older records whose owner_id may not have been populated.
    _ownerId =
        widget.group.ownerId ??
        (widget.group.ownerType == GroupOwnerType.location
            ? widget.group.locationId
            : null) ??
        (widget.group.ownerType == GroupOwnerType.organization
            ? widget.group.organizationId
            : null);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _cyan, width: 1.5),
      ),
    );
  }

  Widget _buildOwnershipCard() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.account_tree_outlined, color: _cyan, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Group Ownership',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the organization or location this group '
            'primarily belongs to.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<GroupOwnerType>(
            initialValue: _ownerType,
            isExpanded: true,
            decoration: _decoration('Owner Type *'),
            items: GroupOwnerType.values.map((type) {
              final isSupported =
                  type == GroupOwnerType.organization ||
                  type == GroupOwnerType.location;

              return DropdownMenuItem<GroupOwnerType>(
                value: type,
                enabled: isSupported,
                child: Text(type.label),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return 'Select an owner type.';
              }
              return null;
            },
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                final previousType = _ownerType;

                _ownerType = value;
                _ownerError = null;

                if (value == GroupOwnerType.organization) {
                  _ownerId = widget.group.organizationId;
                } else if (value == GroupOwnerType.location &&
                    previousType != GroupOwnerType.location) {
                  // Require a fresh location when changing owner type.
                  _ownerId = null;
                }
              });
            },
          ),
          const SizedBox(height: 14),
          _buildOwnerField(),
          if (_ownerError != null) ...[
            const SizedBox(height: 6),
            Text(
              _ownerError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOwnerField() {
    switch (_ownerType) {
      case GroupOwnerType.organization:
        return TextFormField(
          key: const ValueKey('organization-owner'),
          initialValue: 'Current Organization',
          enabled: false,
          decoration: _decoration('Owner'),
        );

      case GroupOwnerType.location:
        return GroupOwnerLocationField(
          key: ValueKey(_ownerId),
          organizationId: widget.group.organizationId,
          selectedLocationId: _ownerId,
          onChanged: (location) {
            setState(() {
              _ownerId = location?.id;
              _ownerError = null;
            });
          },
        );

      case GroupOwnerType.program:
      case GroupOwnerType.event:
      case GroupOwnerType.project:
        return TextFormField(
          key: ValueKey('unsupported-owner-$_ownerType'),
          initialValue: '${_ownerType!.label} selection is not available yet.',
          enabled: false,
          decoration: _decoration('Owner'),
        );

      case null:
        return TextFormField(
          enabled: false,
          initialValue: 'Select an owner type above.',
          decoration: _decoration('Owner'),
        );
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final ownerType = _ownerType;
    if (ownerType == null) return;

    final String? ownerIdToSave;

    if (ownerType == GroupOwnerType.organization) {
      ownerIdToSave = widget.group.organizationId;
    } else if (ownerType == GroupOwnerType.location) {
      ownerIdToSave = _ownerId;
    } else {
      // Until these owner types have editable selectors, preserve
      // their existing ownership rather than inventing a new owner.
      ownerIdToSave = widget.group.ownerId;
    }

    if (ownerType == GroupOwnerType.location &&
        (ownerIdToSave == null || ownerIdToSave.trim().isEmpty)) {
      setState(() {
        _ownerError = 'Select a location to own this group.';
      });
      return;
    }

    final String? locationIdToSave;

    if (ownerType == GroupOwnerType.location) {
      locationIdToSave = ownerIdToSave;
    } else if (ownerType == GroupOwnerType.organization) {
      locationIdToSave = null;
    } else {
      locationIdToSave = widget.group.locationId;
    }

    Navigator.of(context).pop(
      GroupEditData(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        groupType: _groupType,
        visibility: _visibility,
        ownerType: ownerType,
        ownerId: ownerIdToSave,
        locationId: locationIdToSave,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return AlertDialog(
      title: const Text('Edit Group'),
      content: SizedBox(
        width: screenSize.width < 720 ? screenSize.width * 0.86 : 560,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenSize.height * 0.72),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Update the group details below.',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  _buildOwnershipCard(),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: _decoration('Group Name *'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a group name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _decoration(
                      'Description',
                      hint: 'Describe the purpose of this group.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<GroupType>(
                    initialValue: _groupType,
                    isExpanded: true,
                    decoration: _decoration('Group Type'),
                    items: GroupType.values.map((type) {
                      return DropdownMenuItem<GroupType>(
                        value: type,
                        child: Text(type.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _groupType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<GroupVisibility>(
                    initialValue: _visibility,
                    isExpanded: true,
                    decoration: _decoration('Visibility'),
                    items: GroupVisibility.values.map((visibility) {
                      return DropdownMenuItem<GroupVisibility>(
                        value: visibility,
                        child: Text(visibility.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _visibility = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_outlined, size: 18),
          label: const Text('Save Changes'),
          style: FilledButton.styleFrom(
            backgroundColor: _purple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
