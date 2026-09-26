import 'package:flutter/material.dart';

class GroupsViewToggle extends StatelessWidget {
  final bool showMembers;
  final ValueChanged<bool> onChanged;

  const GroupsViewToggle({
    super.key,
    required this.showMembers,
    required this.onChanged,
  });

  static const _cyan = Color(0xFF06B6D4);
  static const _navy = Color(0xFF1E293B);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // At narrow widths, use the compact popup control.
        if (width < 200) {
          return Align(
            alignment: Alignment.centerLeft,
            child: _buildCompactControl(context),
          );
        }

        final compact = width < 280;

        return Padding(
          padding: EdgeInsets.only(right: compact ? 8 : 16),
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ToggleButton(
                  label: 'Groups',
                  icon: Icons.groups_outlined,
                  selected: !showMembers,
                  compact: compact,
                  onPressed: () => onChanged(false),
                ),
                _ToggleButton(
                  label: 'Members',
                  icon: Icons.people_outline,
                  selected: showMembers,
                  compact: compact,
                  onPressed: () => onChanged(true),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactControl(BuildContext context) {
    return PopupMenuButton<bool>(
      tooltip: 'Change view',
      initialValue: showMembers,
      onSelected: onChanged,
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => const [
        PopupMenuItem<bool>(
          value: false,
          child: Row(
            children: [
              Icon(Icons.groups_outlined, size: 18, color: _navy),
              SizedBox(width: 8),
              Text('Groups'),
            ],
          ),
        ),
        PopupMenuItem<bool>(
          value: true,
          child: Row(
            children: [
              Icon(Icons.people_outline, size: 18, color: _navy),
              SizedBox(width: 8),
              Text('Members'),
            ],
          ),
        ),
      ],
      child: Container(
        width: 44,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          showMembers ? Icons.people_outline : Icons.groups_outlined,
          size: 20,
          color: _cyan,
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final bool compact;
  final VoidCallback onPressed;

  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.compact,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? GroupsViewToggle._cyan : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 16,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: compact ? 16 : 18,
                color: selected ? Colors.white : GroupsViewToggle._navy,
              ),
              SizedBox(width: compact ? 4 : 7),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : GroupsViewToggle._navy,
                  fontSize: compact ? 12 : 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
