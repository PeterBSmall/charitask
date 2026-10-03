import 'package:flutter/material.dart';

import '../../domain/models/functional_role.dart';

class FunctionalRoleCatalog extends StatelessWidget {
  const FunctionalRoleCatalog({
    super.key,
    required this.roles,
    required this.selectedRoleIds,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onRoleToggled,
    required this.onCreateRole,
  });

  final List<FunctionalRole> roles;
  final Set<String> selectedRoleIds;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<FunctionalRole> onRoleToggled;
  final VoidCallback? onCreateRole;

  static const _purple = Color(0xFF5B3FD3);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Colors.grey.shade200),
          right: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearch(),
          _buildFilters(),
          Expanded(child: _buildRoles()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Role Catalog',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          if (onCreateRole != null)
            TextButton.icon(
              onPressed: onCreateRole,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Role'),
              style: TextButton.styleFrom(foregroundColor: _purple),
            ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: onSearchChanged,
        controller: TextEditingController(text: searchQuery),
        decoration: InputDecoration(
          hintText: 'Search functional roles...',
          prefixIcon: const Icon(Icons.search, size: 20),
          isDense: true,
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _purple),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    const filters = [
      'All Roles',
      'Active Roles',
      'Frequently Used',
      'Leadership',
      'Needs Requirements',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          for (var i = 0; i < filters.length; i++) ...[
            _FilterChip(label: filters[i], selected: i == 0),
            if (i < filters.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }

  Widget _buildRoles() {
    if (roles.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No functional roles found.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      itemCount: roles.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final role = roles[index];
        final selected = selectedRoleIds.contains(role.id);

        return _RoleCard(
          role: role,
          selected: selected,
          onTap: () => onRoleToggled(role),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEDE9FE) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? const Color(0xFFDDD6FE) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? const Color(0xFF5B3FD3) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  final FunctionalRole role;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF5F3FF) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFFC4B5FD)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: selected
                    ? const Color(0xFF5B3FD3)
                    : const Color(0xFF94A3B8),
                size: 21,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    if (role.description != null &&
                        role.description!.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        role.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        if (role.categoryName != null)
                          Flexible(
                            child: Text(
                              role.categoryName!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          '${role.assignmentCount} assigned',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
