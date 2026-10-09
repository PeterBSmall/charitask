import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/functional_role_category.dart';
import 'functional_role_category_icon.dart';

class RoleCategoriesList extends StatelessWidget {
  final List<FunctionalRoleCategory> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;
  final Map<String, int> roleCounts;
  final Map<String, int> assignmentCounts;

  const RoleCategoriesList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.roleCounts,
    required this.assignmentCounts,
  });

  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 12),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _text,
              ),
            ),
          ),
          if (categories.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No categories found.',
                style: TextStyle(fontSize: 14, color: _muted),
              ),
            )
          else
            ...categories.map(
              (category) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _CategoryRow(
                  category: category,
                  selected: category.id == selectedCategoryId,
                  roleCount: roleCounts[category.id] ?? 0,
                  assignmentCount: assignmentCounts[category.id] ?? 0,
                  onTap: () => onCategorySelected(category.id),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final FunctionalRoleCategory category;
  final bool selected;
  final int roleCount;
  final int assignmentCount;
  final VoidCallback onTap;

  const _CategoryRow({
    required this.category,
    required this.selected,
    required this.roleCount,
    required this.assignmentCount,
    required this.onTap,
  });

  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _purple = Color(0xFF5B3FD3);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF0EBFF) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFE3D9FF)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  FunctionalRoleCategoryIcon.forSlug(category.slug),
                  size: 19,
                  color: selected ? _purple : _muted,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: _text,
                      ),
                    ),
                    if (category.isImported) ...[
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EBFF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Imported',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _purple,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 2,
                      children: [
                        _CountText(
                          icon: Icons.work_outline,
                          value: roleCount,
                          label: 'roles',
                        ),
                        _CountText(
                          icon: Icons.people_outline,
                          value: assignmentCount,
                          label: 'assigned',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
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

class _CountText extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _CountText({
    required this.icon,
    required this.value,
    required this.label,
  });

  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: _muted),
        const SizedBox(width: 3),
        Text(
          '$value $label',
          style: const TextStyle(fontSize: 11, color: _muted),
        ),
      ],
    );
  }
}
