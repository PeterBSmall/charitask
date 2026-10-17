import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/ct_search_field.dart';

class PeopleToolbar extends StatelessWidget {
  const PeopleToolbar({
    super.key,
    required this.searchController,
    this.onSearchChanged,
    required this.onColumnsPressed,
    this.onFiltersPressed,
  });

  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback onColumnsPressed;
  final VoidCallback? onFiltersPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 850;
        final buttons = Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ToolbarButton(
              icon: Icons.filter_list,
              label: 'Filters',
              showChevron: true,
              onPressed: onFiltersPressed,
            ),
            _ToolbarButton(
              icon: Icons.view_column_outlined,
              label: 'Columns',
              showChevron: true,
              onPressed: onColumnsPressed,
            ),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CTSearchField(
                controller: searchController,
                hintText:
                    'Search people by name, email, role, group, location, or phone number...',
                onChanged: onSearchChanged,
              ),
              const SizedBox(height: 12),
              buttons,
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: CTSearchField(
                controller: searchController,
                hintText:
                    'Search people by name, email, role, group, location, or phone number...',
                onChanged: onSearchChanged,
              ),
            ),
            const SizedBox(width: 18),
            buttons,
          ],
        );
      },
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.showChevron = false,
  });

  final IconData icon;
  final String label;
  final bool showChevron;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: onPressed == null
                  ? const Color(0xFFE5E7EB)
                  : const Color(0xFFCBD5E1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: onPressed == null
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF334155),
              ),
              const SizedBox(width: 9),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: onPressed == null
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF334155),
                ),
              ),
              if (showChevron) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 19,
                  color: onPressed == null
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF64748B),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
