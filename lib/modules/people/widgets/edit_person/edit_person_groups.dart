import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/group.dart';

class EditPersonGroups extends StatefulWidget {
  const EditPersonGroups({
    super.key,
    required this.memberships,
    required this.availableGroups,
    required this.canManage,
    required this.onAddGroup,
    required this.onEndMembership,
  });

  final List<Map<String, dynamic>> memberships;
  final List<Group> availableGroups;
  final bool canManage;
  final ValueChanged<String> onAddGroup;
  final ValueChanged<String> onEndMembership;

  @override
  State<EditPersonGroups> createState() => _EditPersonGroupsState();
}

class _EditPersonGroupsState extends State<EditPersonGroups> {
  String? _selectedGroupId;

  List<Group> get _unassignedGroups {
    final assignedIds = widget.memberships
        .where((membership) => membership['status'] == 'active')
        .map((membership) => membership['group_id']?.toString())
        .whereType<String>()
        .toSet();

    return widget.availableGroups
        .where((group) => !assignedIds.contains(group.id))
        .toList();
  }

  @override
  void didUpdateWidget(covariant EditPersonGroups oldWidget) {
    super.didUpdateWidget(oldWidget);

    final stillAvailable = _unassignedGroups.any(
      (group) => group.id == _selectedGroupId,
    );

    if (!stillAvailable) {
      _selectedGroupId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Groups',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage the teams, committees, and other groups this person '
          'belongs to. Group membership does not automatically grant '
          'application access.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        if (widget.canManage) ...[
          _buildAddGroupCard(context),
          const SizedBox(height: 20),
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                'Current Group Memberships',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '${widget.memberships.length}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (widget.memberships.isEmpty)
          _buildEmptyState(context)
        else
          ...widget.memberships.map(
            (membership) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildMembershipCard(context, membership),
            ),
          ),
      ],
    );
  }

  Widget _buildAddGroupCard(BuildContext context) {
    final theme = Theme.of(context);
    final groups = _unassignedGroups;

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
              'Assign to a Group',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedGroupId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Select a group',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.groups_outlined),
              ),
              hint: Text(
                groups.isEmpty
                    ? 'No additional groups available'
                    : 'Choose a group',
              ),
              items: groups.map((group) {
                final typeLabel = group.groupType?.label;
                final label = typeLabel == null
                    ? group.name
                    : '${group.name} · $typeLabel';

                return DropdownMenuItem<String>(
                  value: group.id,
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
              onChanged: groups.isEmpty
                  ? null
                  : (value) {
                      setState(() {
                        _selectedGroupId = value;
                      });
                    },
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _selectedGroupId == null
                    ? null
                    : () => widget.onAddGroup(_selectedGroupId!),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Assign Group'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipCard(
    BuildContext context,
    Map<String, dynamic> membership,
  ) {
    final theme = Theme.of(context);
    final groupId = membership['group_id']?.toString();
    final group = _findGroup(groupId);
    final groupData = _embeddedGroupData(membership);

    final groupName =
        group?.name ?? groupData?['name']?.toString() ?? 'Group unavailable';

    final groupType =
        group?.groupType?.label ??
        GroupType.fromValue(groupData?['group_type']?.toString())?.label;

    final role = membership['membership_role']?.toString() ?? 'member';
    final roleLabel = role.replaceAll('_', ' ');

    final startedAt = DateTime.tryParse(
      membership['started_at']?.toString() ?? '',
    );

    final membershipId = membership['id']?.toString();

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
              Icons.groups_outlined,
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
                  groupName,
                  softWrap: true,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  groupType == null ? roleLabel : '$roleLabel · $groupType',
                  softWrap: true,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (startedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Member since ${MaterialLocalizations.of(context).formatMediumDate(startedAt)}',
                    softWrap: true,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.canManage && membershipId != null)
            IconButton(
              tooltip: 'End group membership',
              onPressed: () => widget.onEndMembership(membershipId),
              icon: Icon(
                Icons.remove_circle_outline,
                color: theme.colorScheme.error,
              ),
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
            Icons.groups_outlined,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(
            'No group memberships',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.canManage
                ? 'Use the selector above to assign this person to a group.'
                : 'There are no current group memberships.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Group? _findGroup(String? groupId) {
    for (final group in widget.availableGroups) {
      if (group.id == groupId) return group;
    }

    return null;
  }

  Map<String, dynamic>? _embeddedGroupData(Map<String, dynamic> membership) {
    final raw = membership['groups'];

    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }

    if (raw is List && raw.isNotEmpty && raw.first is Map) {
      return Map<String, dynamic>.from(raw.first as Map);
    }

    return null;
  }
}
