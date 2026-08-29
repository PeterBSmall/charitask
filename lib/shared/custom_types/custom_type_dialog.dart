import 'package:flutter/material.dart';

import 'custom_type.dart';
import 'custom_type_icon_picker.dart';

class CustomTypeDialog extends StatefulWidget {
  final String title;
  final String typeLabel;
  final List<String> categories;
  final List<CustomType> existingTypes;

  const CustomTypeDialog({
    super.key,
    required this.title,
    required this.typeLabel,
    required this.categories,
    required this.existingTypes,
  });

  @override
  State<CustomTypeDialog> createState() => _CustomTypeDialogState();
}

class _CustomTypeDialogState extends State<CustomTypeDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  IconData _selectedIcon = Icons.category_outlined;

  String? _errorText;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorText = 'Please enter a name.';
      });
      return;
    }

    final normalizedName = name.toLowerCase();

    final duplicate = widget.existingTypes.any(
      (type) => type.name.trim().toLowerCase() == normalizedName,
    );

    if (duplicate) {
      setState(() {
        _errorText =
            'A ${widget.typeLabel.toLowerCase()} with this name already exists.';
      });
      return;
    }

    Navigator.of(context).pop(
      CustomType(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        category: _selectedCategory ?? widget.categories.first,
        icon: _selectedIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: SingleChildScrollView(
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

                const SizedBox(height: 6),

                Text(
                  'Create a custom ${widget.typeLabel.toLowerCase()} that fits your organization.',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 24),

                _buildLabel('${widget.typeLabel} Name *'),

                const SizedBox(height: 8),

                TextField(
                  controller: _nameController,
                  autofocus: true,
                  onChanged: (_) {
                    if (_errorText != null) {
                      setState(() {
                        _errorText = null;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter a name',
                    errorText: _errorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF5B3FC4),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _buildLabel('Description'),

                const SizedBox(height: 8),

                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Optional description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF5B3FC4),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _buildLabel('Category'),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: const Text('Select a category'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
                    ),
                  ),
                  items: widget.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                _buildLabel('Icon'),

                const SizedBox(height: 10),

                CustomTypeIconPicker(
                  selectedIcon: _selectedIcon,
                  onChanged: (icon) {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B3FC4),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Add ${widget.typeLabel}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }
}
