import 'package:flutter/material.dart';

class PeopleTable extends StatelessWidget {
  const PeopleTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          const _PeopleTableHeader(),

          const Divider(height: 1),

          _PeopleRow(
            initials: 'PS',
            name: 'Peter Small',
            email: 'peter@example.com',
            role: 'Administrator',
            groups: 'Leadership',
            locations: 'Main Office',
            status: 'Active',
            phone: '(508) 555-1234',
            lastActive: 'Now',
          ),

          const Divider(height: 1),

          _PeopleRow(
            initials: 'SJ',
            name: 'Sarah Johnson',
            email: 'sarah@example.com',
            role: 'Manager',
            groups: 'Operations',
            locations: 'Yarmouth',
            status: 'Active',
            phone: '(508) 555-2345',
            lastActive: '2 min ago',
          ),

          const Divider(height: 1),

          _PeopleRow(
            initials: 'MB',
            name: 'Michael Brown',
            email: 'michael@example.com',
            role: 'Volunteer',
            groups: 'Volunteers',
            locations: 'Falmouth',
            status: 'Invited',
            phone: '(508) 555-3456',
            lastActive: '—',
          ),

          const Divider(height: 1),

          _PeopleRow(
            initials: 'ED',
            name: 'Emily Davis',
            email: 'emily@example.com',
            role: 'Staff',
            groups: 'ReStore Team',
            locations: 'Yarmouth',
            status: 'Inactive',
            phone: '(508) 555-4567',
            lastActive: 'Aug 18',
          ),
        ],
      ),
    );
  }
}

class _PeopleTableHeader extends StatelessWidget {
  const _PeopleTableHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          SizedBox(width: 250, child: _HeaderText('NAME')),

          Expanded(child: _HeaderText('ROLE')),

          Expanded(child: _HeaderText('GROUP(S)')),

          Expanded(child: _HeaderText('LOCATION(S)')),

          SizedBox(width: 100, child: _HeaderText('STATUS')),

          SizedBox(width: 150, child: _HeaderText('PHONE')),

          SizedBox(width: 110, child: _HeaderText('LAST ACTIVE')),
        ],
      ),
    );
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
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}

class _PeopleRow extends StatelessWidget {
  final String initials;
  final String name;
  final String email;
  final String role;
  final String groups;
  final String locations;
  final String status;
  final String phone;
  final String lastActive;

  const _PeopleRow({
    required this.initials,
    required this.name,
    required this.email,
    required this.role,
    required this.groups,
    required this.locations,
    required this.status,
    required this.phone,
    required this.lastActive,
  });

  Color get _statusColor {
    switch (status) {
      case 'Active':
        return const Color(0xFF5F8D63);

      case 'Invited':
        return const Color(0xFFC8872E);

      case 'Inactive':
        return const Color(0xFF6B7280);

      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          SizedBox(
            width: 250,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFEDE9FE),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Color(0xFF5B4BC4),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F3A4A),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        email,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF7B8494),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(child: _CellText(role)),

          Expanded(child: _CellText(groups)),

          Expanded(child: _CellText(locations)),

          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _StatusBadge(label: status, color: _statusColor),
            ),
          ),

          SizedBox(width: 150, child: _CellText(phone)),

          SizedBox(width: 110, child: _CellText(lastActive)),
        ],
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;

  const _CellText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
