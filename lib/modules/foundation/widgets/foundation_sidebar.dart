import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/navigation/ct_sidebar.dart';
import 'package:charitask/shared/widgets/navigation/ct_tile.dart';

class FoundationSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const FoundationSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CTSidebar(
      header: _buildHeader(),

      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 12),

          CTTile(
            icon: Icons.grid_view_rounded,
            label: 'Dashboard',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),

          CTTile(
            icon: Icons.account_balance_outlined,
            label: 'Organization',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),

          CTTile(
            icon: Icons.people_outline_rounded,
            label: 'People',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),

          CTTile(
            icon: Icons.group_outlined,
            label: 'Groups',
            selected: selectedIndex == 3,
            onTap: () => onSelected(3),
          ),

          CTTile(
            icon: Icons.shield_outlined,
            label: 'Security',
            selected: selectedIndex == 4,
            onTap: () => onSelected(4),
          ),

          CTTile(
            icon: Icons.bar_chart_outlined,
            label: 'Analytics',
            selected: selectedIndex == 5,
            onTap: () => onSelected(5),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Divider(),
          ),

          CTTile(
            icon: Icons.sticky_note_2_outlined,
            label: 'Notes',
            selected: selectedIndex == 6,
            onTap: () => onSelected(6),
            trailing: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF5B4BC4),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),

      footer: Column(
        children: [
          const Divider(height: 1),

          const SizedBox(height: 12),

          CTTile(
            icon: Icons.help_outline_rounded,
            label: 'Help',
            selected: false,
            onTap: () {},
          ),

          CTTile(
            icon: Icons.logout_rounded,
            label: 'Log Out',
            selected: false,
            onTap: () {},
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF5B4BC4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organization Workspace',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F3A4A),
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'Workspace',
                  style: TextStyle(fontSize: 13, color: Color(0xFF7B8494)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
