import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';

class EditPersonLocations extends StatefulWidget {
  const EditPersonLocations({
    super.key,
    required this.assignments,
    required this.availableLocations,
    required this.canManage,
    required this.onAssignLocation,
    required this.onSetPrimary,
    required this.onEndAssignment,
  });

  final List<Map<String, dynamic>> assignments;
  final List<Location> availableLocations;
  final bool canManage;

  /// Receives the location ID and whether it should be the primary location.
  final void Function(String locationId, bool makePrimary) onAssignLocation;

  /// Receives the location ID that should become primary.
  final ValueChanged<String> onSetPrimary;

  /// Receives the assignment ID to end.
  final ValueChanged<String> onEndAssignment;

  @override
  State<EditPersonLocations> createState() => _EditPersonLocationsState();
}

class _EditPersonLocationsState extends State<EditPersonLocations> {
  String? _selectedLocationId;
  bool _makePrimary = false;

  List<Location> get _unassignedLocations {
    final assignedIds = widget.assignments
        .where((assignment) => assignment['status'] == 'active')
        .map((assignment) => assignment['location_id']?.toString())
        .whereType<String>()
        .toSet();

    return widget.availableLocations
        .where((location) => !assignedIds.contains(location.id))
        .toList();
  }

  @override
  void didUpdateWidget(covariant EditPersonLocations oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_unassignedLocations.any(
      (location) => location.id == _selectedLocationId,
    )) {
      _selectedLocationId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Locations',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage the locations where this person works or participates. '
          'One active location can be designated as their primary location.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        if (widget.canManage) ...[
          _buildAssignCard(context),
          const SizedBox(height: 20),
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                'Current Location Assignments',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${widget.assignments.length}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.assignments.isEmpty)
          _buildEmptyState(context)
        else
          ...widget.assignments.map(
            (assignment) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildAssignmentCard(context, assignment),
            ),
          ),
      ],
    );
  }

  Widget _buildAssignCard(BuildContext context) {
    final theme = Theme.of(context);
    final locations = _unassignedLocations;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assign a Location',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedLocationId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Select a location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              hint: Text(
                locations.isEmpty
                    ? 'No additional locations available'
                    : 'Choose a location',
              ),
              items: locations.map((location) {
                final type = location.locationType?.trim();
                final label = type == null || type.isEmpty
                    ? location.name
                    : '${location.name} · $type';

                return DropdownMenuItem<String>(
                  value: location.id,
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: locations.isEmpty
                  ? null
                  : (value) {
                      setState(() {
                        _selectedLocationId = value;
                      });
                    },
            ),
            const SizedBox(height: 6),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Make this the primary location'),
              value: _makePrimary,
              onChanged: (value) {
                setState(() {
                  _makePrimary = value ?? false;
                });
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _selectedLocationId == null
                    ? null
                    : () {
                        widget.onAssignLocation(
                          _selectedLocationId!,
                          _makePrimary,
                        );
                      },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Assign Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(
    BuildContext context,
    Map<String, dynamic> assignment,
  ) {
    final theme = Theme.of(context);
    final locationId = assignment['location_id']?.toString();
    final location = _findLocation(locationId);
    final locationData = _embeddedLocationData(assignment);

    final locationName =
        location?.name ??
        locationData?['name']?.toString() ??
        'Location unavailable';

    final locationType =
        location?.locationType ?? locationData?['location_type']?.toString();

    final isPrimary = assignment['is_primary'] == true;
    final assignmentId = assignment['id']?.toString();
    final startedAt = DateTime.tryParse(
      assignment['started_at']?.toString() ?? '',
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrimary
              ? theme.colorScheme.primary.withValues(alpha: 0.45)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.location_on_outlined,
              size: 20,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locationName,
                  softWrap: true,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (locationType != null && locationType.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    locationType,
                    softWrap: true,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (startedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Assigned ${MaterialLocalizations.of(context).formatMediumDate(startedAt)}',
                    softWrap: true,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (isPrimary) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      avatar: const Icon(Icons.star, size: 16),
                      label: const Text('Primary Location'),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.canManage && assignmentId != null)
            PopupMenuButton<String>(
              tooltip: 'Location assignment actions',
              onSelected: (action) {
                switch (action) {
                  case 'primary':
                    if (locationId != null && !isPrimary) {
                      widget.onSetPrimary(locationId);
                    }
                  case 'end':
                    widget.onEndAssignment(assignmentId);
                }
              },
              itemBuilder: (context) => [
                if (!isPrimary)
                  const PopupMenuItem<String>(
                    value: 'primary',
                    child: Text('Make Primary'),
                  ),
                const PopupMenuItem<String>(
                  value: 'end',
                  child: Text('End Assignment'),
                ),
              ],
              icon: const Icon(Icons.more_vert),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(
            'No location assignments',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.canManage
                ? 'Use the selector above to assign this person to a location.'
                : 'There are no current location assignments.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Location? _findLocation(String? locationId) {
    for (final location in widget.availableLocations) {
      if (location.id == locationId) return location;
    }

    return null;
  }

  Map<String, dynamic>? _embeddedLocationData(Map<String, dynamic> assignment) {
    final raw = assignment['locations'];

    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }

    if (raw is List && raw.isNotEmpty && raw.first is Map) {
      return Map<String, dynamic>.from(raw.first as Map);
    }

    return null;
  }
}
