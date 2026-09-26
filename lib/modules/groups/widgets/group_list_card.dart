import 'package:flutter/material.dart';

import '../domain/models/group.dart';
import 'group_owner_line.dart';
import 'group_type_badge.dart';

class GroupListCard extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onManageMembers;
  final VoidCallback? onViewActivity;
  final VoidCallback? onDuplicate;
  final VoidCallback? onArchive;

  const GroupListCard({
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
  static const _border = Color(0xFFE2E8F0);
  static const _cyan = Color(0xFF06B6D4);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x07000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 14),
              Expanded(child: _buildMainContent()),
              const SizedBox(width: 18),
              _buildMembers(),
              const SizedBox(width: 22),
              GroupOwnerLine(ownerType: group.ownerType),
              const SizedBox(width: 10),
              _buildMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFE6F9FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.groups_outlined, color: _cyan, size: 23),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                group.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GroupTypeBadge(type: group.groupType),
          ],
        ),
        if (group.description != null &&
            group.description!.trim().isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            group.description!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _gray, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildMembers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          group.memberCount.toString(),
          style: const TextStyle(
            color: _navy,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'members',
          style: TextStyle(
            color: _gray,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<_GroupListAction>(
      tooltip: 'Group actions',
      icon: const Icon(Icons.more_vert_rounded, color: _gray),
      onSelected: _handleAction,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _GroupListAction.edit,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.edit_outlined),
            title: Text('Edit Group'),
          ),
        ),
        PopupMenuItem(
          value: _GroupListAction.manageMembers,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.people_outline),
            title: Text('Manage Members'),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: _GroupListAction.viewActivity,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.bar_chart_outlined),
            title: Text('View Activity'),
          ),
        ),
        PopupMenuItem(
          value: _GroupListAction.duplicate,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.copy_outlined),
            title: Text('Duplicate Group'),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: _GroupListAction.archive,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.archive_outlined),
            title: Text('Archive Group'),
          ),
        ),
      ],
    );
  }

  void _handleAction(_GroupListAction action) {
    switch (action) {
      case _GroupListAction.edit:
        onEdit?.call();
        break;
      case _GroupListAction.manageMembers:
        onManageMembers?.call();
        break;
      case _GroupListAction.viewActivity:
        onViewActivity?.call();
        break;
      case _GroupListAction.duplicate:
        onDuplicate?.call();
        break;
      case _GroupListAction.archive:
        onArchive?.call();
        break;
    }
  }
}

enum _GroupListAction { edit, manageMembers, viewActivity, duplicate, archive }
