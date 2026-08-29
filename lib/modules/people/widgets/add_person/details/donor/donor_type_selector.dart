import 'package:flutter/material.dart';

import 'package:charitask/shared/custom_types/custom_type.dart';
import 'package:charitask/shared/custom_types/custom_type_dialog.dart';

import 'donor_type_option.dart';

class DonorTypeSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  final List<CustomType> customTypes;
  final ValueChanged<CustomType> onCustomTypeAdded;

  const DonorTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
    required this.customTypes,
    required this.onCustomTypeAdded,
  });

  static const List<DonorTypeOption> options = [
    DonorTypeOption(
      value: 'individual',
      title: 'Individual Donor',
      description: 'Gives personally to support your organization.',
      icon: Icons.person_outline_rounded,
    ),
    DonorTypeOption(
      value: 'major',
      title: 'Major Donor',
      description: 'Provides significant financial support.',
      icon: Icons.workspace_premium_outlined,
    ),
    DonorTypeOption(
      value: 'recurring',
      title: 'Recurring Donor',
      description: 'Provides ongoing or scheduled contributions.',
      icon: Icons.repeat_rounded,
    ),
    DonorTypeOption(
      value: 'corporate',
      title: 'Corporate Donor',
      description: 'Contributes through a business or company.',
      icon: Icons.business_outlined,
    ),
    DonorTypeOption(
      value: 'foundation_grantor',
      title: 'Foundation / Grantor',
      description: 'Provides funding through a foundation or grant.',
      icon: Icons.account_balance_outlined,
    ),
    DonorTypeOption(
      value: 'in_kind',
      title: 'In-Kind Donor',
      description: 'Donates goods, services, space, or other resources.',
      icon: Icons.volunteer_activism_outlined,
    ),
    DonorTypeOption(
      value: 'sponsor',
      title: 'Sponsor',
      description: 'Supports a program, event, initiative, or mission.',
      icon: Icons.handshake_outlined,
    ),
  ];

  Future<void> _showAddCustomTypeDialog(BuildContext context) async {
    final builtInTypes = options
        .map(
          (option) => CustomType(
            id: option.value,
            name: option.title,
            description: option.description,
            category: 'Built-in',
            icon: option.icon,
          ),
        )
        .toList();

    final allExistingTypes = [...builtInTypes, ...customTypes];

    final newType = await showDialog<CustomType>(
      context: context,
      builder: (context) {
        return CustomTypeDialog(
          title: 'Add custom donor type',
          typeLabel: 'Donor Type',
          categories: const ['Financial', 'In-Kind', 'Sponsorship', 'Other'],
          existingTypes: allExistingTypes,
        );
      },
    );

    if (newType != null) {
      onCustomTypeAdded(newType);
      onChanged(newType.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...options.map(
          (option) => _buildOption(
            title: option.title,
            description: option.description,
            icon: option.icon,
            optionValue: option.value,
          ),
        ),

        ...customTypes.map(
          (customType) => _buildOption(
            title: customType.name,
            description: customType.description ?? 'Custom donor type',
            icon: customType.icon,
            optionValue: customType.id,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: InkWell(
            onTap: () => _showAddCustomTypeDialog(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD9D5F2), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.add_circle_outline_rounded,
                      color: Color(0xFF5B3FC4),
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add custom donor type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5B3FC4),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Define a donor type that fits your organization.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF5B3FC4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required String title,
    required String description,
    required IconData icon,
    required String optionValue,
  }) {
    final isSelected = value == optionValue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onChanged(optionValue),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF1EEFF) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF5B3FC4)
                  : const Color(0xFFE1E4EA),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF5B3FC4)
                      : const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : const Color(0xFF5B3FC4),
                  size: 23,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2F3A4A),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: isSelected
                    ? const Color(0xFF5B3FC4)
                    : const Color(0xFFB8C0CC),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
