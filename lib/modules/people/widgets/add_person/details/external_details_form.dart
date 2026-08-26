import 'package:flutter/material.dart';

class ExternalDetailsForm extends StatelessWidget {
  final String relationshipType;
  final String relationshipStatus;
  final TextEditingController organizationController;
  final TextEditingController startDateController;

  final ValueChanged<String> onRelationshipTypeChanged;
  final ValueChanged<String> onRelationshipStatusChanged;

  const ExternalDetailsForm({
    super.key,
    required this.relationshipType,
    required this.relationshipStatus,
    required this.organizationController,
    required this.startDateController,
    required this.onRelationshipTypeChanged,
    required this.onRelationshipStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(
          icon: Icons.handshake_outlined,
          title: 'Relationship',
          description:
              'Define how this person is connected to your organization.',
        ),

        const SizedBox(height: 24),

        _buildDropdownField(
          label: 'Relationship Type',
          value: relationshipType,
          items: const [
            'Donor',
            'Customer',
            'Vendor',
            'Partner',
            'Contact',
            'Other',
          ],
          icon: Icons.account_tree_outlined,
          onChanged: onRelationshipTypeChanged,
        ),

        const SizedBox(height: 24),

        _buildOrganizationField(),

        const SizedBox(height: 40),

        const Divider(height: 1),

        const SizedBox(height: 40),

        _buildSectionLabel(
          icon: Icons.link_outlined,
          title: 'Relationship Status',
          description: 'Track the current status of this relationship.',
        ),

        const SizedBox(height: 24),

        _buildDropdownField(
          label: 'Status',
          value: relationshipStatus,
          items: const ['Active', 'Inactive', 'Prospect'],
          icon: Icons.verified_outlined,
          onChanged: onRelationshipStatusChanged,
        ),

        const SizedBox(height: 24),

        _buildDateField(context),

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
            color: const Color(0xFFEAF7F8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF3D7F88), size: 22),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF3D7F88)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6E4E6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6E4E6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3D7F88), width: 2),
            ),
          ),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildOrganizationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Organization / Company',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: organizationController,
          decoration: InputDecoration(
            hintText: 'Optional',
            prefixIcon: const Icon(
              Icons.business_outlined,
              color: Color(0xFF3D7F88),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6E4E6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6E4E6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3D7F88), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Relationship Start Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: startDateController,
          readOnly: true,
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            if (selectedDate != null) {
              startDateController.text =
                  '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}';
            }
          },
          decoration: InputDecoration(
            hintText: 'Optional',
            prefixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF3D7F88),
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
              borderSide: const BorderSide(color: Color(0xFFD6E4E6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD6E4E6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3D7F88), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
