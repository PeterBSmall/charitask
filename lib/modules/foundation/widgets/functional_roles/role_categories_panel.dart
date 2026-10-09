import 'package:flutter/material.dart';

import '../../domain/models/functional_role.dart';
import '../../domain/models/functional_role_category.dart';

class RoleCategoriesPanel extends StatelessWidget {
  final List<FunctionalRoleCategory> categories;
  final List<FunctionalRole> roles;
  final FunctionalRoleCategory? selectedCategory;
  final TextEditingController searchController;
  final ValueChanged<FunctionalRoleCategory?> onCategorySelected;

  const RoleCategoriesPanel({
    super.key,
    required this.categories,
    required this.roles,
    required this.selectedCategory,
    required this.searchController,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _panelDecoration(),
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildSearch(),
          const SizedBox(height: 12),
          _buildCategoryList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Select a category to view available roles.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search categories...',
        prefixIcon: const Icon(Icons.search, size: 19),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      onChanged: (_) {},
    );
  }

  Widget _buildCategoryList() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, _) {
        final query = value.text.trim().toLowerCase();

        final filtered = categories.where((category) {
          return query.isEmpty || category.name.toLowerCase().contains(query);
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < filtered.length; index++) ...[
              if (index > 0) const SizedBox(height: 4),
              _buildCategoryItem(filtered[index]),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCategoryItem(FunctionalRoleCategory category) {
    final selected = selectedCategory?.id == category.id;

    final roleCount = roles
        .where((role) => role.categoryId == category.id)
        .length;

    return Material(
      color: selected ? const Color(0xFFF0EBFF) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onCategorySelected(category),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          child: Row(
            children: [
              Icon(
                Icons.business_outlined,
                size: 19,
                color: selected
                    ? const Color(0xFF5B3FD3)
                    : const Color(0xFF475569),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected
                        ? const Color(0xFF5B3FD3)
                        : const Color(0xFF334155),
                  ),
                ),
              ),
              Text(
                '$roleCount',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 17,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    );
  }
}
