import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/ct_date_picker_field.dart';

class PersonalDetailsSection extends StatelessWidget {
  final TextEditingController dateOfBirthController;

  const PersonalDetailsSection({
    super.key,
    required this.dateOfBirthController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),

        const SizedBox(height: 28),

        const Text(
          'Personal details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F3A4A),
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Add information that may help determine eligibility and recognition.',
          style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF6B7280)),
        ),

        const SizedBox(height: 20),

        CTDatePickerField(
          controller: dateOfBirthController,
          label: 'Date of birth',
          hint: 'Select date of birth',
        ),
      ],
    );
  }
}
