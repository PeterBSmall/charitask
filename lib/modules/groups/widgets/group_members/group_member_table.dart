import 'package:flutter/material.dart';

class GroupMemberTable extends StatelessWidget {
  final List<Map<String, dynamic>> members;
  final bool isCompact;
  final void Function(Map<String, dynamic> member)? onRemoveMember;

  const GroupMemberTable({
    super.key,
    required this.members,
    required this.isCompact,
    this.onRemoveMember,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: isCompact ? _buildCompactList() : _buildDesktopTable(),
    );
  }

  Widget _buildDesktopTable() {
    return Column(
      children: [
        _buildTableHeader(),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        ...members.map(_buildMemberRow),
      ],
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 3, child: _HeaderText('Name')),
          Expanded(flex: 3, child: _HeaderText('Email')),
          Expanded(flex: 2, child: _HeaderText('Role')),
          Expanded(flex: 2, child: _HeaderText('Status')),
          Expanded(flex: 2, child: _HeaderText('Joined')),
          SizedBox(width: 48, child: _HeaderText('')),
        ],
      ),
    );
  }

  Widget _buildMemberRow(Map<String, dynamic> member) {
    final person = _personFromMember(member);
    final name = _personDisplayName(person);
    final email = person['email']?.toString().trim() ?? '';
    final role = _roleLabel(member['membership_role']);
    final status = member['status']?.toString() ?? 'active';
    final joined = _formatJoinedDate(member['started_at']);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _buildPersonCell(name, email)),
          Expanded(
            flex: 3,
            child: Text(
              email.isEmpty ? '—' : email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              role,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              status == 'active' ? 'Active' : status,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              joined,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ),
          SizedBox(
            width: 48,
            child: PopupMenuButton<String>(
              tooltip: 'Member actions',
              icon: const Icon(
                Icons.more_vert,
                size: 20,
                color: Color(0xFF64748B),
              ),
              onSelected: (value) {
                if (value == 'remove') {
                  onRemoveMember?.call(member);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_remove_outlined,
                        size: 18,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text('Remove Member'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonCell(String name, String email) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.10),
          child: Text(
            _initials(name),
            style: const TextStyle(
              color: Color(0xFF7C3AED),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactList() {
    return Column(children: members.map(_buildCompactMember).toList());
  }

  Widget _buildCompactMember(Map<String, dynamic> member) {
    final person = _personFromMember(member);
    final name = _personDisplayName(person);
    final email = person['email']?.toString().trim() ?? '';
    final role = _roleLabel(member['membership_role']);
    final status = member['status']?.toString() ?? 'active';
    final joined = _formatJoinedDate(member['started_at']);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.10),
            child: Text(
              _initials(name),
              style: const TextStyle(
                color: Color(0xFF7C3AED),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '$role • ${status == 'active' ? 'Active' : status} • Joined $joined',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _personFromMember(Map<String, dynamic> member) {
    final value = member['persons'];

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return <String, dynamic>{};
  }

  String _personDisplayName(Map<String, dynamic> person) {
    final preferredName = person['preferred_name']?.toString().trim();
    final firstName = person['first_name']?.toString().trim() ?? '';
    final lastName = person['last_name']?.toString().trim() ?? '';

    if (preferredName != null && preferredName.isNotEmpty) {
      return [preferredName, if (lastName.isNotEmpty) lastName].join(' ');
    }

    final fullName = [
      firstName,
      lastName,
    ].where((value) => value.isNotEmpty).join(' ');

    return fullName.isEmpty ? 'Unknown Person' : fullName;
  }

  String _roleLabel(dynamic value) {
    switch (value?.toString()) {
      case 'leader':
        return 'Leader';
      case 'co_leader':
        return 'Co-Leader';
      case 'coordinator':
        return 'Coordinator';
      default:
        return 'Member';
    }
  }

  String _formatJoinedDate(dynamic value) {
    if (value == null) return '—';

    final date = DateTime.tryParse(value.toString());

    if (date == null) return '—';

    return '${date.month}/${date.day}/${date.year}';
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}'
            '${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF64748B),
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
