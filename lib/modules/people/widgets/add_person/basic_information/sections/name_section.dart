import 'package:flutter/material.dart';

import '../widgets/person_text_field.dart';

class NameSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController preferredNameController;

  const NameSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.preferredNameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Name',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F3A4A),
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'How should this person appear in ChariTask?',
          style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF6B7280)),
        ),

        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            final stackFields = constraints.maxWidth < 600;

            if (stackFields) {
              return Column(
                children: [
                  PersonTextField(
                    controller: firstNameController,
                    label: 'First name',
                    hint: 'Enter first name',
                    required: true,
                  ),

                  const SizedBox(height: 16),

                  PersonTextField(
                    controller: lastNameController,
                    label: 'Last name',
                    hint: 'Enter last name',
                    required: true,
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: PersonTextField(
                    controller: firstNameController,
                    label: 'First name',
                    hint: 'Enter first name',
                    required: true,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: PersonTextField(
                    controller: lastNameController,
                    label: 'Last name',
                    hint: 'Enter last name',
                    required: true,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        PersonTextField(
          controller: preferredNameController,
          label: 'Preferred name',
          hint: 'Optional',
        ),
      ],
    );
  }
}
