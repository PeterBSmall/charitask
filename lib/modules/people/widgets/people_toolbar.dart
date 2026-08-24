import 'package:flutter/material.dart';

class PeopleToolbar extends StatelessWidget {
  const PeopleToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Color(0xFF6B7280)),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Search people by name, email, role, group, location, or phone number...',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 24),

        _ToolbarButton(
          icon: Icons.filter_list,
          label: 'Filters',
          showChevron: true,
        ),

        const SizedBox(width: 12),

        _ToolbarButton(
          icon: Icons.view_column_outlined,
          label: 'Columns',
          showChevron: true,
        ),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showChevron;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF374151)),

          const SizedBox(width: 10),

          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),

          if (showChevron) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Color(0xFF6B7280),
            ),
          ],
        ],
      ),
    );
  }
}
