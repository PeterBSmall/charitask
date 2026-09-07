import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/navigation/ct_sidebar.dart';
import 'package:charitask/shared/widgets/navigation/ct_tile.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'foundation_workspace_switcher.dart';
import 'foundation_sidebar_search.dart';

class FoundationSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const FoundationSidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return _buildCollapsedSidebar(context);
    }

    return CTSidebar(
      header: _buildHeader(),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 12),
            const FoundationWorkspaceSwitcher(),

            const SizedBox(height: 8),

            const FoundationSidebarSearch(),

            const SizedBox(height: 12),

            _buildSectionLabel('Main'),

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
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Divider(),
            ),

            _buildSectionLabel('Tools'),

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

            CTTile(
              icon: Icons.settings_outlined,
              label: 'Settings',
              selected: selectedIndex == 7,
              onTap: () => onSelected(7),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Divider(),
            ),

            _buildSectionLabel('Support'),

            CTTile(
              icon: Icons.help_outline_rounded,
              label: 'Help',
              selected: false,
              onTap: () {},
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),

      footer: Column(
        children: [
          const Divider(height: 1),

          const SizedBox(height: 8),

          _buildCollapseButton(),

          const SizedBox(height: 8),

          CTTile(
            icon: Icons.logout_rounded,
            label: 'Log Out',
            selected: false,
            onTap: () async {
              try {
                await Supabase.instance.client.auth.signOut();

                if (!context.mounted) return;

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              } catch (error) {
                debugPrint('>>> LOGOUT ERROR: $error');
              }
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCollapsedSidebar(BuildContext context) {
    return Container(
      color: const Color(0xFFF1EEE8),
      child: Column(
        children: [
          const SizedBox(height: 24),

          _buildCollapsedIcon(
            icon: Icons.account_balance_rounded,
            tooltip: 'Organization Workspace',
            selected: false,
          ),

          const SizedBox(height: 20),

          _buildCollapsedIcon(
            icon: Icons.grid_view_rounded,
            tooltip: 'Dashboard',
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),

          _buildCollapsedIcon(
            icon: Icons.account_balance_outlined,
            tooltip: 'Organization',
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),

          _buildCollapsedIcon(
            icon: Icons.people_outline_rounded,
            tooltip: 'People',
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),

          _buildCollapsedIcon(
            icon: Icons.group_outlined,
            tooltip: 'Groups',
            selected: selectedIndex == 3,
            onTap: () => onSelected(3),
          ),

          _buildCollapsedIcon(
            icon: Icons.shield_outlined,
            tooltip: 'Security',
            selected: selectedIndex == 4,
            onTap: () => onSelected(4),
          ),

          _buildCollapsedIcon(
            icon: Icons.bar_chart_outlined,
            tooltip: 'Analytics',
            selected: selectedIndex == 5,
            onTap: () => onSelected(5),
          ),

          const Spacer(),

          _buildCollapsedIcon(
            icon: Icons.sticky_note_2_outlined,
            tooltip: 'Notes',
            selected: selectedIndex == 6,
            onTap: () => onSelected(6),
            showDot: true,
          ),

          _buildCollapsedIcon(
            icon: Icons.settings_outlined,
            tooltip: 'Settings',
            selected: selectedIndex == 7,
            onTap: () => onSelected(7),
          ),

          const SizedBox(height: 8),

          _buildCollapsedIcon(
            icon: Icons.chevron_right_rounded,
            tooltip: 'Expand navigation',
            selected: false,
            onTap: onToggleCollapse,
          ),

          const SizedBox(height: 12),

          _buildCollapsedIcon(
            icon: Icons.logout_rounded,
            tooltip: 'Log Out',
            selected: false,
            onTap: () async {
              try {
                await Supabase.instance.client.auth.signOut();

                if (!context.mounted) return;

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              } catch (error) {
                debugPrint('>>> LOGOUT ERROR: $error');
              }
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCollapsedIcon({
    required IconData icon,
    required String tooltip,
    required bool selected,
    VoidCallback? onTap,
    bool showDot = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Tooltip(
        message: tooltip,
        waitDuration: const Duration(milliseconds: 350),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 52,
                  height: 46,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFE5DFFF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: selected
                        ? const Color(0xFF5B4BC4)
                        : const Color(0xFF5F5A54),
                  ),
                ),

                if (showDot)
                  Positioned(
                    right: 7,
                    top: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF5B4BC4),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapseButton() {
    return Tooltip(
      message: 'Collapse navigation',
      waitDuration: const Duration(milliseconds: 350),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onToggleCollapse,
          child: SizedBox(
            height: 42,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.chevron_left_rounded,
                  size: 23,
                  color: Color(0xFF5F5A54),
                ),
                SizedBox(width: 4),
                Text(
                  'Collapse',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5F5A54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF7B8494),
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
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
