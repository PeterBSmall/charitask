import 'package:flutter/material.dart';

class RoleCategoryTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final int roleCount;

  const RoleCategoryTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.roleCount,
  });

  static const _purple = Color(0xFF5B3FD3);
  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    final labels = ['Roles ($roleCount)', 'Overview', 'Settings'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 500;

        if (compact) {
          return Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(
              labels.length,
              (index) => _TabButton(
                label: labels[index],
                selected: selectedIndex == index,
                onTap: () => onChanged(index),
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: List.generate(
              labels.length,
              (index) => Expanded(
                child: _TabButton(
                  label: labels[index],
                  selected: selectedIndex == index,
                  onTap: () => onChanged(index),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _purple = Color(0xFF5B3FD3);
  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected ? _purple : _muted,
            ),
          ),
        ),
      ),
    );
  }
}
