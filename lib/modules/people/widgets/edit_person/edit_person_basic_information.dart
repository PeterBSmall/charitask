import 'package:flutter/material.dart';

import 'functional_roles_summary_card.dart';

class EditPersonBasicInformation extends StatelessWidget {
  const EditPersonBasicInformation({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.preferredNameController,
    required this.emailController,
    required this.phoneController,
    required this.notesController,
    required this.engagementType,
    required this.personType,
    required this.status,
    required this.personTypeOptions,
    required this.statusOptions,
    required this.onEngagementTypeChanged,
    required this.onPersonTypeChanged,
    required this.onStatusChanged,
    required this.roleNames,
    required this.canManageRoles,
    required this.onManageRoles,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController preferredNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController notesController;

  final String engagementType;
  final String personType;
  final String status;

  final List<String> personTypeOptions;
  final List<String> statusOptions;

  final ValueChanged<String?> onEngagementTypeChanged;
  final ValueChanged<String?> onPersonTypeChanged;
  final ValueChanged<String?> onStatusChanged;

  final List<String> roleNames;
  final bool canManageRoles;
  final VoidCallback onManageRoles;

  String? _availableValue(String value, List<String> options) {
    return options.contains(value) ? value : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage this person’s information and relationship with your organization.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 16.0;
            final useTwoColumns = constraints.maxWidth >= 640;
            final fieldWidth = useTwoColumns
                ? (constraints.maxWidth - spacing) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: spacing,
              runSpacing: 16,
              children: [
                _textField(
                  width: fieldWidth,
                  controller: firstNameController,
                  label: 'First Name',
                  required: true,
                ),
                _textField(
                  width: fieldWidth,
                  controller: lastNameController,
                  label: 'Last Name',
                  required: true,
                ),
                _textField(
                  width: fieldWidth,
                  controller: preferredNameController,
                  label: 'Preferred Name',
                ),
                _textField(
                  width: fieldWidth,
                  label: 'Engagement Type',
                  initialValue: engagementType,
                  onChanged: (value) => onEngagementTypeChanged(value),
                  textCapitalization: TextCapitalization.words,
                ),
                _dropdownField(
                  width: fieldWidth,
                  label: 'Person Type',
                  value: _availableValue(personType, personTypeOptions),
                  options: personTypeOptions,
                  onChanged: onPersonTypeChanged,
                ),
                _dropdownField(
                  width: fieldWidth,
                  label: 'Status',
                  value: _availableValue(status, statusOptions),
                  options: statusOptions,
                  onChanged: onStatusChanged,
                ),
                _textField(
                  width: fieldWidth,
                  controller: emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                ),
                _textField(
                  width: fieldWidth,
                  controller: phoneController,
                  label: 'Phone',
                  keyboardType: TextInputType.phone,
                  textCapitalization: TextCapitalization.none,
                ),
                _textField(
                  width: constraints.maxWidth,
                  controller: notesController,
                  label: 'Notes',
                  maxLines: 4,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        FunctionalRolesSummaryCard(
          roleNames: roleNames,
          canManage: canManageRoles,
          onManageRoles: onManageRoles,
        ),
      ],
    );
  }

  Widget _textField({
    required double width,
    TextEditingController? controller,
    String? initialValue,
    ValueChanged<String>? onChanged,
    required String label,
    bool required = false,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    int maxLines = 1,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required.';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _dropdownField({
    required double width,
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option, overflow: TextOverflow.ellipsis),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
