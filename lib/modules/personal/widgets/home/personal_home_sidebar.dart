import 'package:flutter/material.dart';
import 'package:charitask/modules/personal/widgets/home/personal_home_quote.dart';

class PersonalHomeSidebar extends StatelessWidget {
  const PersonalHomeSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.white,
      child: Column(
        children: [
          // ===============================================================
          // BRAND
          // ===============================================================
          SizedBox(
            height: 72,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ChariTask',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF7C4DFF),
                  ),
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          // ===============================================================
          // NAVIGATION
          // ===============================================================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: const [
                _NavigationItem(
                  icon: Icons.home_outlined,
                  label: 'Personal Home',
                  selected: true,
                ),
                _NavigationItem(
                  icon: Icons.dashboard_outlined,
                  label: 'My Workspaces',
                ),
                _NavigationItem(
                  icon: Icons.business_outlined,
                  label: 'My Organizations',
                ),
                _NavigationItem(
                  icon: Icons.mail_outline_rounded,
                  label: 'Invitations & Requests',
                ),
                SizedBox(height: 12),
                _NavigationItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Calendar',
                ),
                _NavigationItem(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'My Tasks',
                ),
                _NavigationItem(
                  icon: Icons.sticky_note_2_outlined,
                  label: 'My Notes',
                ),
                _NavigationItem(
                  icon: Icons.people_outline_rounded,
                  label: 'People',
                ),
              ],
            ),
          ),

          // ===============================================================
          // SETTINGS
          // ===============================================================
          const Divider(height: 1),

          const _NavigationItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
          ),

          const PersonalHomeQuote(),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavigationItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF0EBFF) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: Icon(
          icon,
          size: 21,
          color: selected ? const Color(0xFF7C4DFF) : const Color(0xFF667085),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? const Color(0xFF5B35C8) : const Color(0xFF475467),
          ),
        ),
      ),
    );
  }
}
