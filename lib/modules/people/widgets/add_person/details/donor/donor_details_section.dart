import 'package:flutter/material.dart';

import 'donor_type_selector.dart';
import 'package:charitask/shared/custom_types/custom_type.dart';

class DonorDetailsSection extends StatelessWidget {
  final String? donorType;
  final ValueChanged<String?> onDonorTypeChanged;

  final List<CustomType> customTypes;
  final ValueChanged<CustomType> onCustomTypeAdded;

  const DonorDetailsSection({
    super.key,
    required this.donorType,
    required this.onDonorTypeChanged,
    required this.customTypes,
    required this.onCustomTypeAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Donor Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Choose the type of donor relationship this person has with your organization.',
          style: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF6B7280)),
        ),

        const SizedBox(height: 20),

        DonorTypeSelector(
          value: donorType,
          onChanged: onDonorTypeChanged,
          customTypes: customTypes,
          onCustomTypeAdded: onCustomTypeAdded,
        ),
      ],
    );
  }
}
