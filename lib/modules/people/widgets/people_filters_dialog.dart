import 'package:flutter/material.dart';

class PeopleFilterSelection {
  const PeopleFilterSelection({
    this.personType,
    this.status,
    this.role,
    this.group,
    this.location,
  });

  final String? personType;
  final String? status;
  final String? role;
  final String? group;
  final String? location;

  bool get hasActiveFilters =>
      personType != null ||
      status != null ||
      role != null ||
      group != null ||
      location != null;
}

Future<PeopleFilterSelection?> showPeopleFiltersDialog({
  required BuildContext context,
  required List<String> personTypes,
  required List<String> statuses,
  required List<String> roles,
  required List<String> groups,
  required List<String> locations,
  required PeopleFilterSelection initialSelection,
}) {
  return showDialog<PeopleFilterSelection>(
    context: context,
    builder: (_) => _PeopleFiltersDialog(
      personTypes: personTypes,
      statuses: statuses,
      roles: roles,
      groups: groups,
      locations: locations,
      initialSelection: initialSelection,
    ),
  );
}

class _PeopleFiltersDialog extends StatefulWidget {
  const _PeopleFiltersDialog({
    required this.personTypes,
    required this.statuses,
    required this.roles,
    required this.groups,
    required this.locations,
    required this.initialSelection,
  });

  final List<String> personTypes;
  final List<String> statuses;
  final List<String> roles;
  final List<String> groups;
  final List<String> locations;
  final PeopleFilterSelection initialSelection;

  @override
  State<_PeopleFiltersDialog> createState() => _PeopleFiltersDialogState();
}

class _PeopleFiltersDialogState extends State<_PeopleFiltersDialog> {
  late String _personType;
  late String _status;
  late String _role;
  late String _group;
  late String _location;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialSelection;
    _personType = initial.personType ?? '';
    _status = initial.status ?? '';
    _role = initial.role ?? '';
    _group = initial.group ?? '';
    _location = initial.location ?? '';
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    final availableOptions = [
      if (value.isNotEmpty && !options.contains(value)) value,
      ...options,
    ];

    return DropdownButtonFormField<String>(
      key: ValueKey('$label:$value'),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<String>(value: '', child: Text('All')),
        ...availableOptions.map(
          (option) => DropdownMenuItem<String>(
            value: option,
            child: Text(option, overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }

  void _clearDraft() {
    Navigator.of(context).pop(const PeopleFilterSelection());
  }

  void _apply() {
    Navigator.of(context).pop(
      PeopleFilterSelection(
        personType: _personType.isEmpty ? null : _personType,
        status: _status.isEmpty ? null : _status,
        role: _role.isEmpty ? null : _role,
        group: _group.isEmpty ? null : _group,
        location: _location.isEmpty ? null : _location,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Filter People'),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 460,
          maxHeight: MediaQuery.sizeOf(context).height * 0.60,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Narrow the people list using one or more filters.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                label: 'Person Type',
                value: _personType,
                options: widget.personTypes,
                onChanged: (value) => setState(() => _personType = value ?? ''),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: 'Status',
                value: _status,
                options: widget.statuses,
                onChanged: (value) => setState(() => _status = value ?? ''),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: 'Functional Role',
                value: _role,
                options: widget.roles,
                onChanged: (value) => setState(() => _role = value ?? ''),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: 'Group',
                value: _group,
                options: widget.groups,
                onChanged: (value) => setState(() => _group = value ?? ''),
              ),
              const SizedBox(height: 14),
              _buildDropdown(
                label: 'Location',
                value: _location,
                options: widget.locations,
                onChanged: (value) => setState(() => _location = value ?? ''),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _clearDraft, child: const Text('Clear Filters')),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _apply, child: const Text('Apply Filters')),
      ],
    );
  }
}
