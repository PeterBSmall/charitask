import 'package:flutter/material.dart';

class PersonalWorkspaceSidebarItem {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const PersonalWorkspaceSidebarItem({
    required this.label,
    required this.icon,
    this.iconColor,
    this.onTap,
  });
}

class PersonalWorkspaceSidebar extends StatelessWidget {
  final String workspaceName;
  final List<PersonalWorkspaceSidebarItem> items;
  final String selectedItem;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  const PersonalWorkspaceSidebar({
    super.key,
    required this.workspaceName,
    required this.items,
    required this.selectedItem,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return _buildCollapsedSidebar();
    }

    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE7E8EF))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),

          const Divider(height: 1, color: Color(0xFFE7E8EF)),

          const SizedBox(height: 16),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildSectionLabel('Workspace'),

                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _buildSidebarItem(item),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE7E8EF)),

          _buildCollapseButton(),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final initial = workspaceName.trim().isEmpty
        ? 'P'
        : workspaceName.trim().substring(0, 1).toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF5B4BC4),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
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
                  workspaceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F3A4A),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Personal Workspace',
                  style: TextStyle(fontSize: 12, color: Color(0xFF7B8494)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
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

  Widget _buildSidebarItem(PersonalWorkspaceSidebarItem item) {
    final selected = item.label == selectedItem;

    final iconColor = selected
        ? const Color(0xFF5B4BC4)
        : item.iconColor ?? const Color(0xFF536070);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEDE9FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 21, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? const Color(0xFF5B4BC4)
                        : const Color(0xFF263247),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedSidebar() {
    return Container(
      width: 72,
      color: const Color(0xFFF8F7FF),
      child: Column(
        children: [
          const SizedBox(height: 24),

          _buildCollapsedIcon(
            icon: Icons.person_rounded,
            tooltip: workspaceName,
            selected: false,
          ),

          const SizedBox(height: 20),

          ...items.map(
            (item) => _buildCollapsedIcon(
              icon: item.icon,
              tooltip: item.label,
              selected: item.label == selectedItem,
              onTap: item.onTap,
            ),
          ),

          const Spacer(),

          _buildCollapsedIcon(
            icon: Icons.chevron_right_rounded,
            tooltip: 'Expand navigation',
            selected: false,
            onTap: onToggleCollapse,
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 52,
              height: 46,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFE5DFFF) : Colors.transparent,
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
          child: const SizedBox(
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
}
