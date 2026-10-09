import 'package:flutter/material.dart';

import '../../domain/models/functional_role.dart';
import '../../domain/models/functional_role_category.dart';

class RolesListPanel extends StatelessWidget {
  final List<FunctionalRole> roles;
  final FunctionalRoleCategory? selectedCategory;
  final FunctionalRole? selectedRole;
  final String roleFilter;
  final TextEditingController searchController;

  final ValueChanged<FunctionalRole?> onRoleSelected;
  final ValueChanged<String> onRoleFilterChanged;
  final bool Function(FunctionalRole role) roleFilterMatcher;

  const RolesListPanel({
    super.key,
    required this.roles,
    required this.selectedCategory,
    required this.selectedRole,
    required this.roleFilter,
    required this.searchController,
    required this.onRoleSelected,
    required this.onRoleFilterChanged,
    required this.roleFilterMatcher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _panelDecoration(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildFilters(),
          const SizedBox(height: 12),
          Expanded(child: _buildRoleList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final categoryName = selectedCategory?.name ?? 'Select a category';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Roles (${_filteredRoles.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          categoryName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: roleFilter,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Roles')),
            DropdownMenuItem(value: 'system', child: Text('System Roles')),
            DropdownMenuItem(value: 'custom', child: Text('Custom Roles')),
            DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
          ],
          onChanged: (value) {
            if (value != null) {
              onRoleFilterChanged(value);
            }
          },
        ),
        const SizedBox(height: 8),
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search roles...',
            prefixIcon: const Icon(Icons.search, size: 19),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleList() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: searchController,
      builder: (context, value, _) {
        final query = value.text.trim().toLowerCase();

        final filtered = _filteredRoles.where((role) {
          if (query.isEmpty) return true;

          return role.name.toLowerCase().contains(query) ||
              (role.description?.toLowerCase().contains(query) ?? false);
        }).toList();

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final role = filtered[index];
            final selected = selectedRole?.id == role.id;

            return _RoleCard(
              role: role,
              selected: selected,
              onTap: () => onRoleSelected(role),
            );
          },
        );
      },
    );
  }

  List<FunctionalRole> get _filteredRoles {
    if (selectedCategory == null) return [];

    return roles
        .where((role) => role.categoryId == selectedCategory!.id)
        .where(roleFilterMatcher)
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final FunctionalRole role;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final roleType = role.isImported ? 'System Role' : 'Custom Role';

    return Material(
      color: selected ? const Color(0xFFF0EBFF) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.badge_outlined,
                size: 21,
                color: selected
                    ? const Color(0xFF5B3FD3)
                    : const Color(0xFF475569),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? const Color(0xFF5B3FD3)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      roleType,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5B3FD3),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 14,
                          color: Color(0xFF64748B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${role.assignmentCount} assigned',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              _StatusBadge(active: role.isActive),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: active ? const Color(0xFF15803D) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}
