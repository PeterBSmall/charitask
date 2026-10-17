import 'package:flutter/material.dart';

class EditPersonRoleOption {
  const EditPersonRoleOption({
    required this.id,
    required this.name,
    this.categoryName,
  });

  final String id;
  final String name;
  final String? categoryName;
}

class EditPersonRoleAssignment {
  const EditPersonRoleAssignment({
    required this.id,
    required this.roleName,
    this.assignedAt,
  });

  final String id;
  final String roleName;
  final DateTime? assignedAt;
}

class EditPersonAssignments extends StatefulWidget {
  const EditPersonAssignments({
    super.key,
    required this.assignments,
    required this.availableRoles,
    required this.canManage,
    required this.onAssignRole,
    required this.onEndAssignment,
  });

  final List<EditPersonRoleAssignment> assignments;
  final List<EditPersonRoleOption> availableRoles;
  final bool canManage;

  /// Receives the functional role ID selected for assignment.
  final ValueChanged<String> onAssignRole;

  /// Receives the assignment ID that should be ended.
  final ValueChanged<String> onEndAssignment;

  @override
  State<EditPersonAssignments> createState() => _EditPersonAssignmentsState();
}

class _EditPersonAssignmentsState extends State<EditPersonAssignments> {
  String? _selectedRoleId;

  @override
  void didUpdateWidget(covariant EditPersonAssignments oldWidget) {
    super.didUpdateWidget(oldWidget);

    final selectionStillAvailable = widget.availableRoles.any(
      (role) => role.id == _selectedRoleId,
    );

    if (!selectionStillAvailable) {
      _selectedRoleId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assignments',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage the functional roles assigned to this person. '
          'Functional roles describe their responsibilities in the organization.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        if (widget.canManage) ...[
          _buildAddRoleCard(context),
          const SizedBox(height: 20),
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                'Current Functional Roles',
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
              child: _buildAssignmentCard(context, assignment, primaryColor),
            ),
          ),
      ],
    );
  }

  Widget _buildAddRoleCard(BuildContext context) {
    final theme = Theme.of(context);
    final canSelectRole = widget.availableRoles.isNotEmpty;

    final sortedRoles = [...widget.availableRoles]
      ..sort(
        (a, b) =>
            a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()),
      );

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
              'Assign a Functional Role',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedRoleId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Select a role',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment_ind_outlined),
              ),
              hint: Text(
                canSelectRole
                    ? 'Choose a functional role'
                    : 'No additional roles available',
              ),
              items: sortedRoles.map((role) {
                final category = role.categoryName?.trim();
                final label = category == null || category.isEmpty
                    ? role.name
                    : '${role.name} · $category';

                return DropdownMenuItem<String>(
                  value: role.id,
                  child: Text(label, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: canSelectRole
                  ? (value) {
                      setState(() {
                        _selectedRoleId = value;
                      });
                    }
                  : null,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _selectedRoleId == null
                    ? null
                    : () {
                        widget.onAssignRole(_selectedRoleId!);
                      },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Assign Role'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(
    BuildContext context,
    EditPersonRoleAssignment assignment,
    Color primaryColor,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.assignment_ind_outlined,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.roleName,
                      softWrap: true,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (assignment.assignedAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Assigned ${MaterialLocalizations.of(context).formatMediumDate(assignment.assignedAt!)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.canManage)
                IconButton(
                  tooltip: 'End role assignment',
                  onPressed: () {
                    widget.onEndAssignment(assignment.id);
                  },
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: theme.colorScheme.error,
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
            Icons.assignment_outlined,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(
            'No functional roles assigned',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.canManage
                ? 'Use the selector above to assign this person a role.'
                : 'There are no current functional role assignments.',
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
