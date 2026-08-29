import 'package:flutter/material.dart';

class CTDatePickerField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? helperText;
  final bool required;

  const CTDatePickerField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.firstDate,
    required this.lastDate,
    this.helperText,
    this.required = false,
  });

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

            if (required) ...[
              const SizedBox(width: 4),

              const Text(
                '*',
                style: TextStyle(
                  color: Color(0xFFDC2626),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: _getInitialDate(),
              firstDate: firstDate,
              lastDate: lastDate,
            );

            if (selectedDate != null) {
              controller.text =
                  '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF6B7280),
            ),
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF6B7280),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E4EA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5B3FC4), width: 2),
            ),
          ),
        ),

        if (helperText != null) ...[
          const SizedBox(height: 8),

          Text(
            helperText!,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xFF8A94A6),
            ),
          ),
        ],
      ],
    );
  }

  DateTime _getInitialDate() {
    if (controller.text.isNotEmpty) {
      final parts = controller.text.split('/');

      if (parts.length == 3) {
        final month = int.tryParse(parts[0]);
        final day = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);

        if (month != null && day != null && year != null) {
          final date = DateTime(year, month, day);

          if (!date.isBefore(firstDate) && !date.isAfter(lastDate)) {
            return date;
          }
        }
      }
    }

    return lastDate;
  }
}
