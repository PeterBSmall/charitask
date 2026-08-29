import 'package:flutter/material.dart';

import 'member_type_selector.dart';
import '../external_relationship_selector.dart';
import 'donor/donor_details_section.dart';
import 'package:charitask/shared/custom_types/custom_type.dart';

class DetailsForm extends StatelessWidget {
  final String connectionType;
  final String roleCategory;
  final String? donorType;

  final ValueChanged<String> onRoleCategoryChanged;
  final ValueChanged<String?> onDonorTypeChanged;

  final List<CustomType> customTypes;
  final ValueChanged<CustomType> onCustomTypeAdded;

  const DetailsForm({
    super.key,
    required this.connectionType,
    required this.roleCategory,
    required this.donorType,
    required this.onRoleCategoryChanged,
    required this.onDonorTypeChanged,
    required this.customTypes,
    required this.onCustomTypeAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(
          icon: Icons.hub_outlined,
          title: 'Primary Relationship',
          description:
              'Choose how this person is connected to your organization.',
          helperText:
              'This helps us tailor communication, assignments, and access.',
        ),

        const SizedBox(height: 24),

        if (connectionType == 'external')
          ExternalRelationshipSelector(
            value: roleCategory,
            onChanged: onRoleCategoryChanged,
          )
        else
          MemberTypeSelector(
            value: roleCategory,
            onChanged: onRoleCategoryChanged,
          ),

        // Show donor details only when Donor is selected.
        if (roleCategory == 'Donor') ...[
          const SizedBox(height: 32),

          DonorDetailsSection(
            donorType: donorType,
            onDonorTypeChanged: onDonorTypeChanged,
            customTypes: customTypes,
            onCustomTypeAdded: onCustomTypeAdded,
          ),
        ],

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionLabel({
    required IconData icon,
    required String title,
    required String description,
    String? helperText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF1EEFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF5B3FC4), size: 22),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F3A4A),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF6B7280),
                ),
              ),

              if (helperText != null) ...[
                const SizedBox(height: 8),

                Text(
                  helperText,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF8A94A6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
