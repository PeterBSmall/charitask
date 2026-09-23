import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/design_system.dart';

class AddLocationDetailsCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String? locationType;
  final List<String> locationTypes;
  final ValueChanged<String?> onLocationTypeChanged;
  final bool isActive;
  final ValueChanged<bool?> onStatusChanged;

  const AddLocationDetailsCard({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.locationType,
    required this.locationTypes,
    required this.onLocationTypeChanged,
    required this.isActive,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 190,
            decoration: BoxDecoration(
              color: const Color(0xFF059669),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF059669),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Location Details',
                      style: AppTypography.title.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Basic information about this location.',
                      style: AppTypography.caption.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Location Name',
                          hintText: 'e.g. Falmouth ReStore',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Location name is required.';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: locationType,
                        decoration: const InputDecoration(
                          labelText: 'Location Type',
                          border: OutlineInputBorder(),
                        ),
                        items: locationTypes
                            .map(
                              (type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: onLocationTypeChanged,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Location type is required.';
                          }

                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<bool>(
                        initialValue: isActive,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem<bool>(
                            value: true,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Color(0xFF16A34A),
                                ),
                                SizedBox(width: 8),
                                Text('Active'),
                              ],
                            ),
                          ),
                          DropdownMenuItem<bool>(
                            value: false,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Color(0xFF64748B),
                                ),
                                SizedBox(width: 8),
                                Text('Inactive'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: onStatusChanged,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Optional',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
