import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/ct_date_picker_field.dart';

class PersonalDetailsSection extends StatelessWidget {
  final TextEditingController dateOfBirthController;
  final TextEditingController providerNameController;
  final TextEditingController providerRelationshipController;
  final String informationProviderType;
  final ValueChanged<String> onInformationProviderTypeChanged;

  const PersonalDetailsSection({
    super.key,
    required this.dateOfBirthController,
    required this.providerNameController,
    required this.providerRelationshipController,
    required this.informationProviderType,
    required this.onInformationProviderTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final needsProviderDetails =
        informationProviderType == 'parent_guardian' ||
        informationProviderType == 'authorized_representative';

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

        const SizedBox(height: 28),

        const Text(
          'Who is providing this information?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          initialValue: informationProviderType,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
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
          items: const [
            DropdownMenuItem(
              value: 'self',
              child: Text('The person themselves'),
            ),
            DropdownMenuItem(
              value: 'parent_guardian',
              child: Text('Parent or legal guardian'),
            ),
            DropdownMenuItem(
              value: 'authorized_representative',
              child: Text('Authorized representative'),
            ),
            DropdownMenuItem(
              value: 'organization_staff',
              child: Text('Organization staff member'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              onInformationProviderTypeChanged(value);
            }
          },
        ),

        if (needsProviderDetails) ...[
          const SizedBox(height: 20),

          TextField(
            controller: providerNameController,
            decoration: InputDecoration(
              labelText: informationProviderType == 'parent_guardian'
                  ? 'Parent or guardian name'
                  : 'Representative name',
              hintText: 'Enter full name',
              filled: true,
              fillColor: Colors.white,
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

          const SizedBox(height: 16),

          TextField(
            controller: providerRelationshipController,
            decoration: InputDecoration(
              labelText: 'Relationship to the person',
              hintText: 'e.g. Parent, legal guardian, case manager',
              filled: true,
              fillColor: Colors.white,
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
        ],
      ],
    );
  }
}
