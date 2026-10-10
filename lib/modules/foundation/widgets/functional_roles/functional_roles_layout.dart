import 'package:flutter/material.dart';

import '../../domain/models/functional_role.dart';
import '../../domain/models/functional_role_category.dart';
import 'role_categories_panel.dart';
import 'roles_list_panel.dart';
import 'role_details_panel.dart';

class FunctionalRolesLayout extends StatelessWidget {
  final String organizationId;
  final List<FunctionalRoleCategory> categories;
  final List<FunctionalRole> roles;
  final FunctionalRoleCategory? selectedCategory;
  final FunctionalRole? selectedRole;
  final String roleFilter;

  final TextEditingController categorySearchController;
  final TextEditingController roleSearchController;

  final ValueChanged<FunctionalRoleCategory?> onCategorySelected;
  final ValueChanged<FunctionalRole?> onRoleSelected;
  final ValueChanged<String> onRoleFilterChanged;

  final bool Function(FunctionalRole role) roleFilterMatcher;

  final VoidCallback? onRoleArchived;
  final VoidCallback? onRoleRestored;
  final VoidCallback? onRoleDeleted;

  const FunctionalRolesLayout({
    super.key,
    required this.organizationId,
    required this.categories,
    required this.roles,
    required this.selectedCategory,
    required this.selectedRole,
    required this.roleFilter,
    required this.categorySearchController,
    required this.roleSearchController,
    required this.onCategorySelected,
    required this.onRoleSelected,
    required this.onRoleFilterChanged,
    required this.roleFilterMatcher,
    this.onRoleArchived,
    this.onRoleRestored,
    this.onRoleDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1050) {
          return _buildNarrowLayout(context);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 290,
              child: RoleCategoriesPanel(
                categories: categories,
                roles: roles,
                selectedCategory: selectedCategory,
                searchController: categorySearchController,
                onCategorySelected: onCategorySelected,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 330,
              child: RolesListPanel(
                roles: roles,
                selectedCategory: selectedCategory,
                selectedRole: selectedRole,
                roleFilter: roleFilter,
                searchController: roleSearchController,
                onRoleSelected: onRoleSelected,
                onRoleFilterChanged: onRoleFilterChanged,
                roleFilterMatcher: roleFilterMatcher,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildDetails(context)),
          ],
        );
      },
    );
  }

  Widget _buildDetails(BuildContext context) {
    if (selectedRole == null || selectedCategory == null) {
      return _buildEmptyDetails();
    }

    return RoleDetailsPanel(
      organizationId: organizationId,
      category: selectedCategory!,
      role: selectedRole!,
      onRoleArchived: onRoleArchived,
      onRoleRestored: onRoleRestored,
      onRoleDeleted: onRoleDeleted,
    );
  }

  Widget _buildEmptyDetails() {
    return Container(
      decoration: _panelDecoration(),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.badge_outlined, size: 42, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            'Select a role',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Select a role from the middle panel to view its details.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;

        return DefaultTabController(
          length: 3,
          child: Container(
            height: availableHeight,
            decoration: _panelDecoration(),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                const SizedBox(
                  height: 48,
                  child: TabBar(
                    tabs: [
                      Tab(text: 'Categories'),
                      Tab(text: 'Roles'),
                      Tab(text: 'Details'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      RoleCategoriesPanel(
                        categories: categories,
                        roles: roles,
                        selectedCategory: selectedCategory,
                        searchController: categorySearchController,
                        onCategorySelected: onCategorySelected,
                      ),
                      RolesListPanel(
                        roles: roles,
                        selectedCategory: selectedCategory,
                        selectedRole: selectedRole,
                        roleFilter: roleFilter,
                        searchController: roleSearchController,
                        onRoleSelected: onRoleSelected,
                        onRoleFilterChanged: onRoleFilterChanged,
                        roleFilterMatcher: roleFilterMatcher,
                      ),
                      _buildDetails(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
