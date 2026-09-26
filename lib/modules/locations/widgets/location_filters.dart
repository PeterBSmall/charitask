import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/shared/design_system/design_system.dart';

class LocationFilters extends StatelessWidget {
  final List<Location> locations;
  final String searchQuery;
  final String? selectedType;
  final String? selectedStatus;
  final String? selectedState;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onStateChanged;
  final VoidCallback onClear;

  const LocationFilters({
    super.key,
    required this.locations,
    required this.searchQuery,
    required this.selectedType,
    required this.selectedStatus,
    required this.selectedState,
    required this.onSearchChanged,
    required this.onTypeChanged,
    required this.onStatusChanged,
    required this.onStateChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final types =
        locations
            .map((location) => location.locationType)
            .whereType<String>()
            .where((type) => type.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    final states =
        locations
            .map((location) => location.state)
            .whereType<String>()
            .where((state) => state.trim().isNotEmpty)
            .toSet()
            .toList()
          ..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search locations...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () => onSearchChanged(''),
                          icon: const Icon(Icons.clear),
                        ),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterDropdown(
              label: 'Location Type',
              value: selectedType,
              items: types,
              onChanged: onTypeChanged,
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterDropdown(
              label: 'Status',
              value: selectedStatus,
              items: const ['Active', 'Inactive'],
              onChanged: onStatusChanged,
            ),
            const SizedBox(width: AppSpacing.sm),
            _FilterDropdown(
              label: 'State',
              value: selectedState,
              items: states,
              onChanged: onStateChanged,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _TypeChip(
              label: 'All',
              selected: selectedType == null,
              onTap: () => onTypeChanged(null),
            ),
            for (final type in types)
              _TypeChip(
                label: type,
                selected: selectedType == type,
                onTap: () => onTypeChanged(type),
              ),
            if (searchQuery.isNotEmpty ||
                selectedType != null ||
                selectedStatus != null ||
                selectedState != null)
              TextButton(
                onPressed: onClear,
                child: const Text('Clear filters'),
              ),
          ],
        ),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFFEDE9FE),
      checkmarkColor: const Color(0xFF5B4BC4),
      side: BorderSide(
        color: selected ? const Color(0xFF5B4BC4) : const Color(0xFFE2E8F0),
      ),
    );
  }
}
