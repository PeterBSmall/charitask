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
  static const _lightGray = Color(0xFFF8FAFC);
  static const _border = Color(0xFFE2E8F0);
  static const _cyan = Color(0xFF06B6D4);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
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
              _buildHeader(),
              const SizedBox(height: 14),
              _buildDescription(),
              const SizedBox(height: 16),
              GroupOwnerLine(ownerType: group.ownerType),
              const SizedBox(height: 16),
              _buildMemberSummary(),
              if (group.membershipComposition.isNotEmpty) ...[
                const SizedBox(height: 14),
                _buildComposition(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F9FC),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.groups_outlined, color: _cyan, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              GroupTypeBadge(type: group.groupType),
            ],
          ),
        ),
        _buildMenu(),
      ],
    );
  }

  Widget _buildDescription() {
    final description = group.description?.trim();

    if (description == null || description.isEmpty) {
      return const Text(
        'No description provided.',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: _gray,
          fontSize: 13,
          height: 1.45,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Text(
      description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: _gray, fontSize: 13, height: 1.45),
    );
  }

  Widget _buildMemberSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          const Icon(Icons.people_outline, size: 19, color: _cyan),
          const SizedBox(width: 8),
          Text(
            group.memberCount.toString(),
            style: const TextStyle(
              color: _navy,
              fontSize: 18,
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

  Widget _buildComposition() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: group.membershipComposition
          .map((type) => _CompositionChip(type: type))
          .toList(),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<_GroupCardAction>(
      tooltip: 'Group actions',
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

  const _CompositionChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        type.label,
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
