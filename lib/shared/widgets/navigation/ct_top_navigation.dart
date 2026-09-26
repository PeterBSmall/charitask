import 'package:flutter/material.dart';

class CTTopNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onCustomize;
  final bool isCustomizing;

  const CTTopNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.onCustomize,
    required this.isCustomizing,
  });

  static const _items = ['Overview', 'Tasks', 'Activity', 'Notes', 'Reports'];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 450) {
          return _buildUltraCompactNavigation();
        }

        if (width < 800) {
          return _buildCompactNavigation();
        }

        if (width < 1100) {
          return _buildMediumNavigation();
        }

        return _buildFullNavigation();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Full desktop navigation
  // ---------------------------------------------------------------------------

  Widget _buildFullNavigation() {
    return _buildShell(
      height: 72,
      horizontalPadding: 32,
      child: Row(
        children: [
          Expanded(child: _buildScrollableNav(compact: false)),
          const SizedBox(width: 16),
          _buildCustomizeButton(),
          const SizedBox(width: 12),
          _buildSearchField(width: 320),
          const SizedBox(width: 10),
          _buildIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 6),
          _buildIconButton(icon: Icons.help_outline_rounded, onTap: () {}),
          const SizedBox(width: 8),
          _buildProfileAvatar(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Medium navigation
  //
  // Keeps search and essential utility controls, but removes the long
  // "Customize Dashboard" label.
  // ---------------------------------------------------------------------------

  Widget _buildMediumNavigation() {
    return _buildShell(
      height: 72,
      horizontalPadding: 20,
      child: Row(
        children: [
          Expanded(child: _buildScrollableNav(compact: true)),
          const SizedBox(width: 8),
          _buildCustomizeIconButton(),
          const SizedBox(width: 8),
          _buildSearchField(width: 180),
          const SizedBox(width: 6),
          _buildIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 6),
          _buildProfileAvatar(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Compact navigation
  //
  // At this width the search/profile/notification controls are optional.
  // Removing them gives the actual page navigation room to breathe.
  // ---------------------------------------------------------------------------

  Widget _buildCompactNavigation() {
    return _buildShell(
      height: 72,
      horizontalPadding: 12,
      child: Row(
        children: [
          Expanded(child: _buildScrollableNav(compact: true)),
          const SizedBox(width: 4),
          _buildCustomizeIconButton(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Ultra compact navigation
  // ---------------------------------------------------------------------------

  Widget _buildUltraCompactNavigation() {
    return _buildShell(
      height: 56,
      horizontalPadding: 4,
      child: Row(
        children: [
          IconButton(
            tooltip: 'Navigation',
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            icon: const Icon(
              Icons.menu_rounded,
              size: 22,
              color: Color(0xFF3D4756),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(child: _buildScrollableNav(compact: true, height: 56)),
          _buildCustomizeIconButton(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared shell
  // ---------------------------------------------------------------------------

  Widget _buildShell({
    required double height,
    required double horizontalPadding,
    required Widget child,
  }) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: child,
    );
  }

  // ---------------------------------------------------------------------------
  // Navigation items
  // ---------------------------------------------------------------------------

  Widget _buildScrollableNav({required bool compact, double height = 72}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          _items.length,
          (index) => _buildNavItem(
            label: _items[index],
            selected: selectedIndex == index,
            onTap: () => onSelected(index),
            compact: compact,
            height: height,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required bool compact,
    required double height,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: compact ? 11 : 16),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: compact ? 14 : 15,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? const Color(0xFF5B4BC4)
                    : const Color(0xFF687385),
              ),
            ),
            if (selected)
              Positioned(
                bottom: 0,
                child: Container(
                  width: compact ? 48 : 58,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B4BC4),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Customize
  // ---------------------------------------------------------------------------

  Widget _buildCustomizeButton() {
    return TextButton.icon(
      onPressed: onCustomize,
      icon: Icon(
        isCustomizing
            ? Icons.check_rounded
            : Icons.dashboard_customize_outlined,
        size: 17,
      ),
      label: Text(isCustomizing ? 'Done' : 'Customize Dashboard'),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF5B4BC4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildCustomizeIconButton() {
    return IconButton(
      tooltip: isCustomizing ? 'Done' : 'Customize Dashboard',
      onPressed: onCustomize,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
      icon: Icon(
        isCustomizing
            ? Icons.check_rounded
            : Icons.dashboard_customize_outlined,
        size: 21,
        color: const Color(0xFF5B4BC4),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  Widget _buildSearchField({required double width}) {
    return SizedBox(
      width: width,
      height: 44,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Color(0xFF8A94A3), fontSize: 14),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF4B5563),
            size: 23,
          ),
          filled: true,
          fillColor: const Color(0xFFF6F7FB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  Widget _buildProfileAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F1F5),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person_rounded,
        color: Color(0xFF5B6472),
        size: 23,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Icon button
  // ---------------------------------------------------------------------------

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF3D4756),
            size: 25,
          ),
        ),
      ),
    );
  }
}
