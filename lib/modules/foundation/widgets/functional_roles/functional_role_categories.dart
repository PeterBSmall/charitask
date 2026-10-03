import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/functional_role_category.dart';

class FunctionalRoleCategories extends StatelessWidget {
  final List<FunctionalRoleCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const FunctionalRoleCategories({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: _border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 18, 20, 4),
            child: Text(
              'Role Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _text,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              'Browse by category to find roles.',
              style: TextStyle(fontSize: 13, color: _muted),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              children: [
                _CategoryTile(
                  icon: Icons.grid_view_rounded,
                  label: 'All Categories',
                  count: categories.length,
                  selected: selectedCategoryId == null,
                  onTap: () => onCategorySelected(null),
                ),
                const SizedBox(height: 4),
                ...categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _CategoryTile(
                      icon: _iconForCategory(category.slug),
                      label: category.name,
                      count: null,
                      selected: selectedCategoryId == category.id,
                      onTap: () => onCategorySelected(category.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static IconData _iconForCategory(String slug) {
    switch (slug) {
      case 'retail-operations':
        return Icons.shopping_cart_outlined;
      case 'volunteer-services':
        return Icons.groups_outlined;
      case 'fundraising':
        return Icons.favorite_outline;
      case 'programs':
        return Icons.people_alt_outlined;
      case 'administration':
        return Icons.description_outlined;
      case 'finance':
        return Icons.bar_chart_outlined;
      case 'facilities':
        return Icons.build_outlined;
      case 'leadership':
        return Icons.star_outline;
      default:
        return Icons.work_outline;
    }
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  static const _purple = Color(0xFF5B3FD3);
  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? _purple : _text;

    return Material(
      color: selected ? const Color(0xFFF0EBFF) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: selected ? _purple : _muted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: foreground,
                  ),
                ),
              ),
              if (count != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFE3D9FF)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: selected ? _purple : _muted,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: selected ? _purple : _muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
