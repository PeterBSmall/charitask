import 'package:flutter/material.dart';

class CustomTypeIconPicker extends StatelessWidget {
  final IconData selectedIcon;
  final ValueChanged<IconData> onChanged;

  const CustomTypeIconPicker({
    super.key,
    required this.selectedIcon,
    required this.onChanged,
  });

  static const List<IconData> _icons = [
    Icons.category_outlined,
    Icons.favorite_border_rounded,
    Icons.volunteer_activism_outlined,
    Icons.workspace_premium_outlined,
    Icons.handshake_outlined,
    Icons.business_outlined,
    Icons.account_balance_outlined,
    Icons.repeat_rounded,
    Icons.person_outline_rounded,
    Icons.groups_outlined,
    Icons.star_outline_rounded,
    Icons.celebration_outlined,
    Icons.campaign_outlined,
    Icons.lightbulb_outline_rounded,
    Icons.more_horiz_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _icons.map((icon) {
        final isSelected = icon == selectedIcon;

        return InkWell(
          onTap: () => onChanged(icon),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFF1EEFF)
                  : const Color(0xFFF7F7F8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF5B3FC4)
                    : const Color(0xFFE1E4EA),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF5B3FC4)
                  : const Color(0xFF6B7280),
              size: 22,
            ),
          ),
        );
      }).toList(),
    );
  }
}
