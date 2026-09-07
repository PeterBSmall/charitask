import 'package:flutter/material.dart';

class CTTopNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CTTopNavigation({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _items = ['Overview', 'Tasks', 'Activity', 'Notes', 'Reports'];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final compact = width < 900;

        return Container(
          height: 72,
          padding: EdgeInsets.symmetric(horizontal: compact ? 20 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
            ),
          ),
          child: Row(
            children: [
              // ------------------------------------------------------------
              // TOP NAVIGATION
              // ------------------------------------------------------------
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      _items.length,
                      (index) => _buildNavItem(
                        label: _items[index],
                        selected: selectedIndex == index,
                        onTap: () => onSelected(index),
                      ),
                    ),
                  ),
                ),
              ),

              // ------------------------------------------------------------
              // SEARCH
              // ------------------------------------------------------------
              SizedBox(
                width: compact ? 180 : 320,
                height: 44,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF8A94A3),
                      fontSize: 14,
                    ),
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
              ),

              const SizedBox(width: 18),

              // ------------------------------------------------------------
              // NOTIFICATIONS
              // ------------------------------------------------------------
              _buildIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () {},
              ),

              const SizedBox(width: 8),

              // ------------------------------------------------------------
              // HELP
              // ------------------------------------------------------------
              _buildIconButton(icon: Icons.help_outline_rounded, onTap: () {}),

              const SizedBox(width: 12),

              // ------------------------------------------------------------
              // PROFILE
              // ------------------------------------------------------------
              Container(
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
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
                  width: 58,
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

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: const Color(0xFF3D4756), size: 25),
        ),
      ),
    );
  }
}
