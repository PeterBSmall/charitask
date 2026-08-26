import 'package:flutter/material.dart';

import 'member_type_selector.dart';

class DetailsForm extends StatelessWidget {
  final String connectionType;
  final String roleCategory;
  final String? donorType;

  final ValueChanged<String> onRoleCategoryChanged;
  final ValueChanged<String?> onDonorTypeChanged;

  const DetailsForm({
    super.key,
    required this.connectionType,
    required this.roleCategory,
    required this.donorType,
    required this.onRoleCategoryChanged,
    required this.onDonorTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(
          icon: Icons.hub_outlined,
          title: 'Relationship Type',
          description:
              'Choose how this person is connected to your organization.',
        ),

        const SizedBox(height: 24),

        MemberTypeSelector(
          value: roleCategory,
          onChanged: onRoleCategoryChanged,
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionLabel({
    required IconData icon,
    required String title,
    required String description,
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
            ],
          ),
        ),
      ],
    );
  }
}
