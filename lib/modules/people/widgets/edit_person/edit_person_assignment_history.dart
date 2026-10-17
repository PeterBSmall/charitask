import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';
import 'package:charitask/modules/groups/data/services/group_membership_service.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';

class EditPersonAssignmentHistory extends StatefulWidget {
  const EditPersonAssignmentHistory({
    super.key,
    required this.organizationId,
    required this.personId,
    required this.canViewGroups,
    required this.canViewLocations,
    required this.canViewFunctionalRoles,
  });

  final String organizationId;
  final String personId;
  final bool canViewGroups;
  final bool canViewLocations;
  final bool canViewFunctionalRoles;

  @override
  State<EditPersonAssignmentHistory> createState() =>
      _EditPersonAssignmentHistoryState();
}

class _EditPersonAssignmentHistoryState
    extends State<EditPersonAssignmentHistory> {
  late final GroupMembershipService _groupService;
  late final LocationService _locationService;
  late final FunctionalRoleService _roleService;

  bool _isLoading = true;
  List<_AssignmentHistoryRecord> _records = [];
  List<String> _loadErrors = [];

  @override
  void initState() {
    super.initState();

    final supabase = Supabase.instance.client;

    _groupService = GroupMembershipService(supabase: supabase);
    _locationService = LocationService(supabase: supabase);
    _roleService = FunctionalRoleService(supabase: supabase);

    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadErrors = [];
      });
    }

    final records = <_AssignmentHistoryRecord>[];
    final errors = <String>[];

    // Group memberships, including ended periods.
    if (widget.canViewGroups) {
      try {
        final memberships = await _groupService.getPersonMemberships(
          organizationId: widget.organizationId,
          personId: widget.personId,
          activeOnly: false,
        );

        for (final membership in memberships) {
          final group = _relationMap(membership['groups']);
          final name = group?['name']?.toString() ?? 'Unavailable group';

          records.add(
            _AssignmentHistoryRecord(
              id: membership['id']?.toString() ?? '',
              type: 'Group',
              name: name,
              status: membership['status']?.toString() ?? 'unknown',
              startedAt: _parseDate(membership['started_at']),
              endedAt: _parseDate(membership['ended_at']),
              details: _formatLabel(membership['membership_role']?.toString()),
            ),
          );
        }
      } catch (error) {
        debugPrint('Group assignment history failed: $error');
        errors.add('Group membership history could not be loaded.');
      }
    }

    // Location assignments, including ended periods.
    if (widget.canViewLocations) {
      try {
        final assignments = await _locationService.getPersonLocationAssignments(
          organizationId: widget.organizationId,
          personId: widget.personId,
          activeOnly: false,
        );

        for (final assignment in assignments) {
          final location = _relationMap(assignment['locations']);
          final name = location?['name']?.toString() ?? 'Unavailable location';

          final details = <String>[];

          final locationType = location?['location_type']?.toString();
          if (locationType != null && locationType.isNotEmpty) {
            details.add(locationType);
          }

          if (assignment['is_primary'] == true) {
            details.add('Primary location');
          }

          records.add(
            _AssignmentHistoryRecord(
              id: assignment['id']?.toString() ?? '',
              type: 'Location',
              name: name,
              status: assignment['status']?.toString() ?? 'unknown',
              startedAt: _parseDate(assignment['started_at']),
              endedAt: _parseDate(assignment['ended_at']),
              details: details.join(' · '),
            ),
          );
        }
      } catch (error) {
        debugPrint('Location assignment history failed: $error');
        errors.add('Location assignment history could not be loaded.');
      }
    }

    // Functional Role assignments, including ended periods.
    if (widget.canViewFunctionalRoles) {
      try {
        final results = await Future.wait([
          _roleService.getRoles(
            organizationId: widget.organizationId,
            activeOnly: false,
          ),
          _roleService.getAssignments(
            organizationId: widget.organizationId,
            personId: widget.personId,
            activeOnly: false,
          ),
        ]);

        final roles = results[0] as List;
        final assignments = results[1] as List;

        final roleNames = {
          for (final role in roles) role.id.toString(): role.name.toString(),
        };

        for (final assignment in assignments) {
          records.add(
            _AssignmentHistoryRecord(
              id: assignment.id,
              type: 'Functional Role',
              name:
                  roleNames[assignment.functionalRoleId] ?? 'Unavailable role',
              status: assignment.status,
              startedAt: assignment.assignedAt,
              endedAt: assignment.endedAt,
            ),
          );
        }
      } catch (error) {
        debugPrint('Functional role assignment history failed: $error');
        errors.add('Functional Role history could not be loaded.');
      }
    }

    // Most recent assignments first. Records without dates appear last.
    records.sort((a, b) {
      if (a.startedAt == null && b.startedAt == null) return 0;
      if (a.startedAt == null) return 1;
      if (b.startedAt == null) return -1;

      return b.startedAt!.compareTo(a.startedAt!);
    });

    if (!mounted) return;

    setState(() {
      _records = records;
      _loadErrors = errors;
      _isLoading = false;
    });
  }

  static Map<String, dynamic>? _relationMap(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    if (value is List && value.isNotEmpty && value.first is Map) {
      return Map<String, dynamic>.from(value.first as Map);
    }

    return null;
  }

  static DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    return DateTime.tryParse(value.toString());
  }

  static String _formatLabel(String? value) {
    if (value == null || value.trim().isEmpty) return '';

    return value
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assignment History',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Review current and ended group memberships, location assignments, '
          'and Functional Role assignments. Historical records are retained.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else ...[
          for (final error in _loadErrors) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          error,
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          if (_records.isEmpty)
            _buildEmptyState(context)
          else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'All Assignments',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${_records.length} records',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._records.map(
              (record) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildRecordCard(context, record),
              ),
            ),
          ],
          if (_loadErrors.isNotEmpty) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _loadHistory,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Loading History'),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildRecordCard(
    BuildContext context,
    _AssignmentHistoryRecord record,
  ) {
    final theme = Theme.of(context);
    final isActive = record.status == 'active';

    final icon = switch (record.type) {
      'Group' => Icons.groups_outlined,
      'Location' => Icons.location_on_outlined,
      _ => Icons.assignment_ind_outlined,
    };

    final statusLabel = isActive
        ? 'Current'
        : record.status == 'inactive'
        ? 'Ended'
        : _formatLabel(record.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
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
              icon,
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
                  record.name,
                  softWrap: true,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.type,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (record.details.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    record.details,
                    softWrap: true,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (record.startedAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Started: ${MaterialLocalizations.of(context).formatMediumDate(record.startedAt!)}',
                    softWrap: true,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                if (record.endedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Ended: ${MaterialLocalizations.of(context).formatMediumDate(record.endedAt!)}',
                    softWrap: true,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Chip(
                label: Text(statusLabel),
                labelStyle: TextStyle(
                  color: isActive
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                backgroundColor: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                side: BorderSide(
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                ),
              ),
            ],
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
            Icons.history,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(
            'No assignment history',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No assignments were found for the categories you can view.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentHistoryRecord {
  const _AssignmentHistoryRecord({
    required this.id,
    required this.type,
    required this.name,
    required this.status,
    required this.startedAt,
    required this.endedAt,
    this.details = '',
  });

  final String id;
  final String type;
  final String name;
  final String status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String details;
}
