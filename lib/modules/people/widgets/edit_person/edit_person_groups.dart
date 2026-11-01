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
    required this.onChangeMembershipRole,
  });

  final List<Map<String, dynamic>> memberships;
  final List<Group> availableGroups;
  final bool canManage;
  final ValueChanged<String> onAddGroup;
  final ValueChanged<String> onEndMembership;
  final void Function(Map<String, dynamic> membership, String membershipRole)
  onChangeMembershipRole;

  @override
  State<EditPersonGroups> createState() => _EditPersonGroupsState();
}

class _EditPersonGroupsState extends State<EditPersonGroups> {
  String? _selectedGroupId;

  static const Map<String, String> _groupRoleLabels = {
    'member': 'Member',
    'leader': 'Leader',
    'co_leader': 'Co-Leader',
    'coordinator': 'Coordinator',
  };

  List<Group> get _unassignedGroups {
    final assignedIds = widget.memberships
        .where((membership) => membership['status'] == 'active')
        .map((membership) => membership['group_id']?.toString())
        .whereType<String>()
        .toSet();

    return widget.availableGroups
        .where((group) => !assignedIds.contains(group.id))
        .toList()
      ..sort(
        (a, b) =>
            a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase()),
      );
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
        GroupType.fromValue(groupData?['group_type']?.toString())?.label ??
        'Not specified';

    final role = membership['membership_role']?.toString() ?? 'member';
    final roleLabel = _groupRoleLabels[role] ?? _formatRoleLabel(role);

    final startedAt = DateTime.tryParse(
      membership['started_at']?.toString() ?? '',
    );

    final memberSince = startedAt == null
        ? 'Not recorded'
        : MaterialLocalizations.of(context).formatMediumDate(startedAt);

    final membershipId = membership['id']?.toString();

    final canEditMembership =
        widget.canManage &&
        membershipId != null &&
        membership['status'] == 'active';

    Widget detailLine(String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text.rich(
          TextSpan(
            style: theme.textTheme.bodyMedium,
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextSpan(
                text: value,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          softWrap: true,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.groups_outlined,
              size: 22,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  softWrap: true,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                detailLine('Role', roleLabel),
                detailLine('Type', groupType),
                detailLine('Member Since', memberSince),
              ],
            ),
          ),
          if (canEditMembership) ...[
            PopupMenuButton<String>(
              tooltip: 'Change group role',
              icon: const Icon(Icons.manage_accounts_outlined),
              onSelected: (selectedRole) {
                if (selectedRole != role) {
                  widget.onChangeMembershipRole(membership, selectedRole);
                }
              },
              itemBuilder: (context) => _groupRoleLabels.entries
                  .map(
                    (entry) => CheckedPopupMenuItem<String>(
                      value: entry.key,
                      checked: entry.key == role,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
            ),
            IconButton(
              tooltip: 'End group membership',
              onPressed: () => widget.onEndMembership(membershipId!),
              icon: Icon(
                Icons.remove_circle_outline,
                color: theme.colorScheme.error,
              ),
            ),
          ],
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

  String _formatRoleLabel(String role) {
    return role
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
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
