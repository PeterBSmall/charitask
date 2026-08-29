import 'package:flutter/material.dart';

class NotesSection extends StatelessWidget {
  final TextEditingController controller;

  const NotesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),

        const SizedBox(height: 28),

        const Text(
          'Notes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F3A4A),
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Add any additional information you would like to keep about this person.',
          style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF6B7280)),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: controller,
          minLines: 4,
          maxLines: 6,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: 'Add notes...',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: const Color(0xFFFBFBFC),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5B3FC4), width: 2),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
