import 'package:flutter/material.dart';

class CreateCustomTypeDialog extends StatefulWidget {
  final String title;
  final String nameLabel;
  final String descriptionLabel;
  final String createButtonLabel;
  final ValueChanged<CustomTypeResult> onCreate;

  const CreateCustomTypeDialog({
    super.key,
    required this.title,
    required this.nameLabel,
    required this.descriptionLabel,
    required this.createButtonLabel,
    required this.onCreate,
  });

  @override
  State<CreateCustomTypeDialog> createState() => _CreateCustomTypeDialogState();
}

class _CreateCustomTypeDialogState extends State<CreateCustomTypeDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _create() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      return;
    }

    widget.onCreate(
      CustomTypeResult(
        name: name,
        description: _descriptionController.text.trim(),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Create a custom type that fits your organization.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                widget.nameLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter a name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                widget.descriptionLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Optional description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(
                    onPressed: _create,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B3FC4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(widget.createButtonLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTypeResult {
  final String name;
  final String description;

  const CustomTypeResult({required this.name, required this.description});
}
