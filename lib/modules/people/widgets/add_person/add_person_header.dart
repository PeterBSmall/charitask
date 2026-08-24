import 'package:flutter/material.dart';

class AddPersonHeader extends StatelessWidget {
  const AddPersonHeader({
    super.key,
    required this.onCancel,
    required this.onSaveDraft,
  });

  final VoidCallback onCancel;
  final VoidCallback onSaveDraft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          const Icon(
            Icons.person_add_alt_1_outlined,
            size: 32,
            color: Color(0xFF5B4BC4),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Person',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F3A4A),
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Add a new person and connect them to your organization.',
                  style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),

          OutlinedButton(onPressed: onCancel, child: const Text('Cancel')),

          const SizedBox(width: 12),

          ElevatedButton(
            onPressed: onSaveDraft,
            child: const Text('Save Draft'),
          ),

          const SizedBox(width: 12),

          IconButton(onPressed: onCancel, icon: const Icon(Icons.close)),
        ],
      ),
    );
  }
}
