import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/ct_search_field.dart';

class PeopleToolbar extends StatelessWidget {
  const PeopleToolbar({
    super.key,
    required this.searchController,
    this.onSearchChanged,
  });

  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 850;

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
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _ToolbarButton(
                    icon: Icons.filter_list,
                    label: 'Filters',
                    showChevron: true,
                  ),
                  _ToolbarButton(
                    icon: Icons.view_column_outlined,
                    label: 'Columns',
                    showChevron: true,
                  ),
                ],
              ),
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
            const SizedBox(width: 24),
            const _ToolbarButton(
              icon: Icons.filter_list,
              label: 'Filters',
              showChevron: true,
            ),
            const SizedBox(width: 12),
            const _ToolbarButton(
              icon: Icons.view_column_outlined,
              label: 'Columns',
              showChevron: true,
            ),
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
    this.showChevron = false,
  });

  final IconData icon;
  final String label;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
