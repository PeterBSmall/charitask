import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/domain/models/group.dart';
import 'package:charitask/modules/groups/data/services/group_membership_service.dart';
import 'package:charitask/modules/groups/widgets/group_members/group_member_table.dart';
import 'package:charitask/modules/groups/widgets/group_members/add_group_members_dialog.dart';

class GroupMembersPage extends StatefulWidget {
  final String organizationId;
  final Group group;

  const GroupMembersPage({
    super.key,
    required this.organizationId,
    required this.group,
  });

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  static const _purple = Color(0xFF7C3AED);
  static const _cyan = Color(0xFF06B6D4);
  static const _darkText = Color(0xFF1E293B);
  static const _mutedText = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _surface = Color(0xFFFFFFFF);
  static const _background = Color(0xFFF8FAFC);

  int _selectedTab = 0;
  final GroupMembershipService _membershipService = GroupMembershipService();

  List<Map<String, dynamic>> _members = [];

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final members = await _membershipService.getMembers(
        organizationId: widget.organizationId,
        groupId: widget.group.id,
      );

      if (!mounted) return;

      setState(() {
        _members = members;
      });
    } catch (error) {
      debugPrint('Unable to load group members: $error');
    }
  }

  Future<void> _removeMember(Map<String, dynamic> member) async {
    final personId = member['person_id'] as String?;
    if (personId == null) return;

    final person = member['persons'] as Map<String, dynamic>?;
    final firstName = person?['first_name'] as String? ?? '';
    final lastName = person?['last_name'] as String? ?? '';
    final name = '$firstName $lastName'.trim();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member?'),
        content: Text(
          'Are you sure you want to remove ${name.isEmpty ? 'this member' : name} '
          'from ${widget.group.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove Member'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _membershipService.removeMember(
        organizationId: widget.organizationId,
        groupId: widget.group.id,
        personId: personId,
      );

      await _loadMembers();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${name.isEmpty ? 'Member' : name} was removed from ${widget.group.name}.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to remove member: $error')),
      );
    }
  }

  Future<void> _changeMemberRole(Map<String, dynamic> member) async {
    final personId = member['person_id']?.toString();

    if (personId == null || personId.isEmpty) return;

    const roles = <String, String>{
      'leader': 'Leader',
      'co_leader': 'Co-Leader',
      'coordinator': 'Coordinator',
      'member': 'Member',
    };

    final currentRole = member['membership_role']?.toString() ?? 'member';

    final selectedRole = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Group Role'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: roles.entries.map((entry) {
              final isSelected = entry.key == currentRole;

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? _cyan : _mutedText,
                ),
                title: Text(entry.value),
                onTap: () {
                  Navigator.of(dialogContext).pop(entry.key);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedRole == null || selectedRole == currentRole || !mounted) {
      return;
    }

    try {
      await _membershipService.updateMemberRole(
        organizationId: widget.organizationId,
        groupId: widget.group.id,
        personId: personId,
        membershipRole: selectedRole,
      );

      await _loadMembers();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group role updated to ${roles[selectedRole]}.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to update group role: $error')),
      );
    }
  }

  Future<void> _addMembers() async {
    final activePersonIds = _members
        .map((member) => member['person_id']?.toString())
        .whereType<String>()
        .toSet();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AddGroupMembersDialog(
        organizationId: widget.organizationId,
        excludedPersonIds: activePersonIds,
      ),
    );

    if (result == null || result.isEmpty || !mounted) return;

    try {
      await _membershipService.addMembers(
        organizationId: widget.organizationId,
        groupId: widget.group.id,
        memberRoles: result,
      );

      await _loadMembers();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added ${result.length} '
            '${result.length == 1 ? 'member' : 'members'} '
            'to ${widget.group.name}.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to add members: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 850;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isCompact ? 16 : 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context, isCompact),
                      const SizedBox(height: 20),
                      _buildTabs(),
                      const SizedBox(height: 20),
                      if (_selectedTab == 0)
                        _buildMembersContent(context, isCompact)
                      else
                        _buildGroupDetailsPlaceholder(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isCompact) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 20 : 28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6D28D9), Color(0xFF7C3AED), Color(0xFF0891B2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCompact)
            _buildCompactHeader(context)
          else
            _buildDesktopHeader(context),
          const SizedBox(height: 22),
          _buildHeaderBadges(isCompact),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildHeaderTitle()),
        const SizedBox(width: 20),
        _buildMemberCount(),
      ],
    );
  }

  Widget _buildCompactHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderTitle(),
        const SizedBox(height: 18),
        _buildMemberCount(),
      ],
    );
  }

  Widget _buildHeaderTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          label: const Text(
            'Back to Groups',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Manage Members',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.group.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Manage the people assigned to this group.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.82),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCount() {
    final memberCount = _members.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$memberCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Members',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBadges(bool isCompact) {
    final badges = [
      _HeaderBadge(
        icon: Icons.location_on_outlined,
        label: 'Owned By Location',
      ),
      _HeaderBadge(
        icon: Icons.groups_outlined,
        label: _groupTypeLabel(widget.group.groupType),
      ),
      _HeaderBadge(icon: Icons.calendar_today_outlined, label: 'Created By'),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: badges
          .map(
            (badge) => Container(
              constraints: BoxConstraints(maxWidth: isCompact ? 260 : 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(badge.icon, size: 16, color: Colors.white),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text(
                      badge.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          _buildTab(
            label: 'Members',
            icon: Icons.people_alt_outlined,
            index: 0,
          ),
          _buildTab(label: 'Group Details', icon: Icons.info_outline, index: 1),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required IconData icon,
    required int index,
  }) {
    final selected = _selectedTab == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: selected
                ? _purple.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? _purple : _mutedText),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? _purple : _mutedText,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembersContent(BuildContext context, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Members',
                    style: TextStyle(
                      color: _darkText,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'People currently assigned to this group.',
                    style: TextStyle(color: _mutedText, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: FilledButton.icon(
                onPressed: _addMembers,
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text('Add Members'),
                style: FilledButton.styleFrom(
                  backgroundColor: _purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GroupMemberTable(
          members: _members,
          isCompact: isCompact,
          onRemoveMember: _removeMember,
          onChangeRole: _changeMemberRole,
        ),
        const SizedBox(height: 16),
        _buildRoleInfoCard(),
      ],
    );
  }

  Widget _buildRoleInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cyan.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cyan.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: _cyan, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Membership Roles',
                  style: TextStyle(
                    color: _darkText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Leader, Co-Leader, Coordinator, and Member describe a person’s role within this group. These are separate from Functional Roles and permissions.',
                  style: TextStyle(
                    color: _mutedText,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupDetailsPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Group Details',
            style: TextStyle(
              color: _darkText,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Group details will be added in a later pass.',
            style: TextStyle(color: _mutedText, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _groupTypeLabel(GroupType? type) {
    if (type == null) return 'Group';

    return switch (type) {
      GroupType.team => 'Team',
      GroupType.committee => 'Committee',
      GroupType.department => 'Department',
      GroupType.cohort => 'Cohort',
      GroupType.participantGroup => 'Participant Group',
      GroupType.leadershipTeam => 'Leadership Team',
      GroupType.staffGroup => 'Staff Group',
      GroupType.volunteerGroup => 'Volunteer Group',
      GroupType.board => 'Board',
      GroupType.donorCircle => 'Donor Circle',
      GroupType.ministry => 'Ministry',
    };
  }
}

class _HeaderBadge {
  final IconData icon;
  final String label;

  const _HeaderBadge({required this.icon, required this.label});
}
