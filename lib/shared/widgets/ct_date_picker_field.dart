import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CTDatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool required;

  const CTDatePickerField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.required = false,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('MM/dd/yyyy').parse(controller.text);
      } catch (_) {}
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'SELECT DATE OF BIRTH',
    );

    if (selectedDate != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),

            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Color(0xFFE5484D),
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(12),
          child: IgnorePointer(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF5B3FC4),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
