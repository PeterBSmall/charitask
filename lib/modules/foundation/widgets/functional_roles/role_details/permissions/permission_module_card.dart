import 'package:flutter/material.dart';

import '../../../../domain/models/permission.dart';

class PermissionModuleCard extends StatelessWidget {
  final String module;
  final List<Permission> permissions;
  final Set<String> selectedIds;
  final bool isSaving;
  final ValueChanged<String> onToggle;
  final VoidCallback onToggleAll;

  const PermissionModuleCard({
    super.key,
    required this.module,
    required this.permissions,
    required this.selectedIds,
    required this.isSaving,
    required this.onToggle,
    required this.onToggleAll,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCount = permissions
        .where((permission) => selectedIds.contains(permission.id))
        .length;

    final allSelected = selectedCount == permissions.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildHeader(selectedCount, allSelected),
          const Divider(height: 1),
          ...permissions.map(_buildPermission),
        ],
      ),
    );
  }

  Widget _buildHeader(int selectedCount, bool allSelected) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _moduleName(module),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$selectedCount / ${permissions.length} '
                  'permissions enabled',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: isSaving ? null : onToggleAll,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF5B3FD3),
              visualDensity: VisualDensity.compact,
            ),
            child: Text(allSelected ? 'Disable All' : 'Enable All'),
          ),
        ],
      ),
    );
  }

  Widget _buildPermission(Permission permission) {
    final selected = selectedIds.contains(permission.id);

    return InkWell(
      onTap: isSaving ? null : () => onToggle(permission.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    permission.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  if (permission.description != null &&
                      permission.description!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      permission.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            Switch.adaptive(
              value: selected,
              onChanged: isSaving ? null : (_) => onToggle(permission.id),
              activeTrackColor: const Color(0xFF5B3FD3),
              activeThumbColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  String _moduleName(String module) {
    switch (module) {
      case 'people':
        return 'People';
      case 'locations':
        return 'Locations';
      case 'groups':
        return 'Groups';
      case 'tasks':
        return 'Tasks';
      case 'functionalrole':
        return 'Functional Roles';
      default:
        return module.isEmpty
            ? module
            : '${module[0].toUpperCase()}'
                  '${module.substring(1)}';
    }
  }
}
