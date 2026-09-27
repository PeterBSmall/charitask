import 'package:flutter/material.dart';

import '../domain/models/group.dart';
import 'group_owner_line.dart';
import 'group_type_badge.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onManageMembers;
  final VoidCallback? onViewActivity;
  final VoidCallback? onDuplicate;
  final VoidCallback? onArchive;

  const GroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.onEdit,
    this.onManageMembers,
    this.onViewActivity,
    this.onDuplicate,
    this.onArchive,
  });

  static const _navy = Color(0xFF1E293B);
  static const _gray = Color(0xFF64748B);
  static const _muted = Color(0xFF94A3B8);
  static const _lightGray = Color(0xFFF8FAFC);
  static const _border = Color(0xFFE2E8F0);
  static const _cyan = Color(0xFF06B6D4);
  static const _cyanLight = Color(0xFFE6F9FC);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 330;

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(compact ? 14 : 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(compact),
                  SizedBox(height: compact ? 12 : 14),
                  _buildDescription(compact),
                  SizedBox(height: compact ? 14 : 16),
                  _buildOwner(),
                  SizedBox(height: compact ? 14 : 16),
                  _buildMemberSummary(compact),
                  if (group.membershipComposition.isNotEmpty) ...[
                    SizedBox(height: compact ? 12 : 14),
                    _buildComposition(compact),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool compact) {
    final iconSize = compact ? 42.0 : 46.0;
    final iconPadding = compact ? 11.0 : 12.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: _cyanLight,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            Icons.groups_outlined,
            color: _cyan,
            size: compact ? 22 : 24,
          ),
        ),
        SizedBox(width: iconPadding),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _navy,
                    fontSize: compact ? 15 : 16,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 7),
                GroupTypeBadge(type: group.groupType),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        _buildMenu(),
      ],
    );
  }

  Widget _buildDescription(bool compact) {
    final description = group.description?.trim();

    if (description == null || description.isEmpty) {
      return Text(
        'No description provided.',
        maxLines: compact ? 2 : 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: _muted,
          fontSize: compact ? 12 : 13,
          height: 1.45,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Text(
      description,
      maxLines: compact ? 2 : 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: _gray, fontSize: compact ? 12 : 13, height: 1.45),
    );
  }

  Widget _buildOwner() {
    return Row(
      children: [
        const Icon(Icons.account_tree_outlined, size: 17, color: _muted),
        const SizedBox(width: 7),
        Expanded(child: GroupOwnerLine(ownerType: group.ownerType)),
      ],
    );
  }

  Widget _buildMemberSummary(bool compact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 11 : 12,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 32 : 34,
            height: compact ? 32 : 34,
            decoration: BoxDecoration(
              color: _cyanLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              Icons.people_outline,
              size: compact ? 17 : 19,
              color: _cyan,
            ),
          ),
          SizedBox(width: compact ? 9 : 10),
          Text(
            group.memberCount.toString(),
            style: TextStyle(
              color: _navy,
              fontSize: compact ? 17 : 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 5),
          const Text(
            'members',
            style: TextStyle(
              color: _gray,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComposition(bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MEMBERSHIP',
          style: TextStyle(
            color: _muted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 7),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: group.membershipComposition
              .map((type) => _CompositionChip(type: type, compact: compact))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<_GroupCardAction>(
      tooltip: 'Group actions',
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert_rounded, color: _gray),
      onSelected: _handleAction,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _GroupCardAction.edit,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit Group'),
          ),
        ),
        PopupMenuItem(
          value: _GroupCardAction.manageMembers,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.people_outline),
            title: Text('Manage Members'),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: _GroupCardAction.viewActivity,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.bar_chart_outlined),
            title: Text('View Activity'),
          ),
        ),
        PopupMenuItem(
          value: _GroupCardAction.duplicate,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.copy_outlined),
            title: Text('Duplicate Group'),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: _GroupCardAction.archive,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.archive_outlined),
            title: Text('Archive Group'),
          ),
        ),
      ],
    );
  }

  void _handleAction(_GroupCardAction action) {
    switch (action) {
      case _GroupCardAction.edit:
        onEdit?.call();
        break;
      case _GroupCardAction.manageMembers:
        onManageMembers?.call();
        break;
      case _GroupCardAction.viewActivity:
        onViewActivity?.call();
        break;
      case _GroupCardAction.duplicate:
        onDuplicate?.call();
        break;
      case _GroupCardAction.archive:
        onArchive?.call();
        break;
    }
  }
}

enum _GroupCardAction { edit, manageMembers, viewActivity, duplicate, archive }

class _CompositionChip extends StatelessWidget {
  final GroupMembershipType type;
  final bool compact;

  const _CompositionChip({required this.type, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 7 : 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          color: const Color(0xFF475569),
          fontSize: compact ? 9 : 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
