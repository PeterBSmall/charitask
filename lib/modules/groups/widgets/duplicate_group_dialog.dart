import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/group.dart';

class DuplicateGroupData {
  final String name;
  final String description;

  const DuplicateGroupData({required this.name, required this.description});
}

class DuplicateGroupDialog extends StatefulWidget {
  final Group group;

  const DuplicateGroupDialog({super.key, required this.group});

  @override
  State<DuplicateGroupDialog> createState() => _DuplicateGroupDialogState();
}

class _DuplicateGroupDialogState extends State<DuplicateGroupDialog> {
  static const _purple = Color(0xFF7C3AED);
  static const _cyan = Color(0xFF06B6D4);
  static const _border = Color(0xFFE2E8F0);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: 'Copy of ${widget.group.name}',
    );
    _descriptionController = TextEditingController(
      text: widget.group.description ?? '',
    );
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
        borderSide: const BorderSide(color: _border),
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
      DuplicateGroupData(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return AlertDialog(
      title: const Text('Duplicate Group'),
      content: SizedBox(
        width: screenSize.width < 720 ? screenSize.width * 0.84 : 520,
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
                    'Create a new group using this group’s definition. '
                    'Members will not be copied.',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: _decoration('New Group Name *'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a name for the new group.';
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
          icon: const Icon(Icons.copy_outlined, size: 18),
          label: const Text('Create Duplicate'),
          style: FilledButton.styleFrom(
            backgroundColor: _purple,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
