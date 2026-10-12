import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/group.dart';

class GroupEditData {
  final String name;
  final String description;
  final GroupType groupType;
  final GroupVisibility visibility;

  const GroupEditData({
    required this.name,
    required this.description,
    required this.groupType,
    required this.visibility,
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

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.group.name);
    _descriptionController = TextEditingController(
      text: widget.group.description ?? '',
    );

    _groupType = widget.group.groupType ?? GroupType.team;
    _visibility = widget.group.visibility;
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      GroupEditData(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        groupType: _groupType,
        visibility: _visibility,
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
