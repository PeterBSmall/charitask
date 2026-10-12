import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/data/services/group_service.dart';
import 'package:charitask/modules/groups/domain/models/group.dart';

class ArchivedGroupsPage extends StatefulWidget {
  final String organizationId;

  const ArchivedGroupsPage({super.key, required this.organizationId});

  @override
  State<ArchivedGroupsPage> createState() => _ArchivedGroupsPageState();
}

class _ArchivedGroupsPageState extends State<ArchivedGroupsPage> {
  static const _purple = Color(0xFF7C3AED);
  static const _cyan = Color(0xFF06B6D4);
  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _background = Color(0xFFF8FAFC);

  final GroupService _groupService = GroupService();

  List<Group> _groups = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadArchivedGroups();
  }

  Future<void> _loadArchivedGroups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final groups = await _groupService.getArchivedGroups(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _restoreGroup(Group group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Restore Group?'),
        content: Text(
          'Restore "${group.name}" to your active Groups list? '
          'Its existing record and membership history will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.unarchive_outlined, size: 18),
            label: const Text('Restore Group'),
            style: FilledButton.styleFrom(
              backgroundColor: _purple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _groupService.restoreGroup(
        groupId: group.id,
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${group.name} was restored successfully.')),
      );

      await _loadArchivedGroups();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to restore group: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Archived Groups',
          style: TextStyle(color: _navy, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: _buildContent(constraints.maxWidth),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(double availableWidth) {
    return Padding(
      padding: EdgeInsets.all(availableWidth < 600 ? 16 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildIntroduction(),
          const SizedBox(height: 20),
          Expanded(child: _buildGroupsList()),
        ],
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _cyan.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.archive_outlined, color: _cyan, size: 23),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Previously Archived',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Archived groups are kept here until you restore them. '
                  'Restoring a group returns it to your active Groups list.',
                  style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 36),
            const SizedBox(height: 12),
            const Text('Unable to load archived groups.'),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _loadArchivedGroups,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.archive_outlined,
              size: 48,
              color: _muted.withValues(alpha: 0.65),
            ),
            const SizedBox(height: 14),
            const Text(
              'No archived groups',
              style: TextStyle(
                color: _navy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Groups you archive will appear here.',
              style: TextStyle(color: _muted, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _groups.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildGroupCard(_groups[index]);
      },
    );
  }

  Widget _buildGroupCard(Group group) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 560;

          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (group.description != null &&
                  group.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(
                  group.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 13),
                ),
              ],
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _metadataChip(
                    Icons.groups_outlined,
                    group.groupType?.label ?? 'Group',
                  ),
                  _metadataChip(
                    Icons.people_outline,
                    '${group.memberCount} members',
                  ),
                  _metadataChip(
                    Icons.visibility_outlined,
                    group.visibility.label,
                  ),
                ],
              ),
            ],
          );

          final restoreButton = OutlinedButton.icon(
            onPressed: () => _restoreGroup(group),
            icon: const Icon(Icons.unarchive_outlined, size: 18),
            label: const Text('Restore'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _purple,
              side: const BorderSide(color: _purple),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                details,
                const SizedBox(height: 16),
                Align(alignment: Alignment.centerRight, child: restoreButton),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: details),
              const SizedBox(width: 20),
              restoreButton,
            ],
          );
        },
      ),
    );
  }

  Widget _metadataChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: _muted),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
