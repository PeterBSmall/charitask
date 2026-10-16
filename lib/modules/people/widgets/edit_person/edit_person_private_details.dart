import 'package:flutter/material.dart';

class EditPersonPrivateDetails extends StatelessWidget {
  const EditPersonPrivateDetails({
    super.key,
    required this.dateOfBirthController,
    required this.informationProviderNameController,
    required this.informationProviderRelationshipController,
    required this.informationProviderType,
    required this.canManage,
    required this.onSelectDate,
    required this.onInformationProviderTypeChanged,
  });

  final TextEditingController dateOfBirthController;
  final TextEditingController informationProviderNameController;
  final TextEditingController informationProviderRelationshipController;

  final String? informationProviderType;
  final bool canManage;

  final VoidCallback onSelectDate;
  final ValueChanged<String?> onInformationProviderTypeChanged;

  static const Map<String, String> _providerTypes = {
    'self': 'Self',
    'parent_guardian': 'Parent / Guardian',
    'authorized_representative': 'Authorized Representative',
    'organization_staff': 'Organization Staff',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    color: theme.colorScheme.primary,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Private Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Date of birth and information-provider details are restricted '
              'to authorized users.',
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
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: dateOfBirthController,
                        readOnly: true,
                        onTap: canManage ? onSelectDate : null,
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          hintText: 'MM/DD/YYYY',
                          border: const OutlineInputBorder(),
                          suffixIcon: canManage
                              ? IconButton(
                                  tooltip: 'Select date of birth',
                                  onPressed: onSelectDate,
                                  icon: const Icon(
                                    Icons.calendar_month_outlined,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: DropdownButtonFormField<String>(
                        initialValue:
                            _providerTypes.containsKey(informationProviderType)
                            ? informationProviderType
                            : null,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Information Provider',
                          border: OutlineInputBorder(),
                        ),
                        items: _providerTypes.entries.map((entry) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(
                              entry.value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: canManage
                            ? onInformationProviderTypeChanged
                            : null,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: informationProviderNameController,
                        readOnly: !canManage,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Provider Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: informationProviderRelationshipController,
                        readOnly: !canManage,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Relationship to Person',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
