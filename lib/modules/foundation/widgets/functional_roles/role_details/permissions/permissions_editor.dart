import 'package:flutter/material.dart';

import '../../../../domain/models/permission.dart';
import 'permission_module_card.dart';

class PermissionsEditor extends StatelessWidget {
  final List<Permission> permissions;
  final Set<String> selectedPermissionIds;
  final bool isSaving;
  final bool hasChanges;
  final ValueChanged<String> onToggle;
  final ValueChanged<List<String>> onToggleAll;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const PermissionsEditor({
    super.key,
    required this.permissions,
    required this.selectedPermissionIds,
    required this.isSaving,
    required this.hasChanges,
    required this.onToggle,
    required this.onToggleAll,
    required this.onCancel,
    required this.onSave,
  });

  static const _moduleOrder = [
    'people',
    'locations',
    'groups',
    'tasks',
    'functionalrole',
  ];

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Permission>>{};

    for (final permission in permissions) {
      grouped.putIfAbsent(permission.module, () => []).add(permission);
    }

    final modules = [
      ..._moduleOrder.where(grouped.containsKey),
      ...grouped.keys.where((module) => !_moduleOrder.contains(module)),
    ];

    return Column(
      children: [
        ...modules.map(
          (module) => PermissionModuleCard(
            module: module,
            permissions: grouped[module]!,
            selectedIds: selectedPermissionIds,
            isSaving: isSaving,
            onToggle: onToggle,
            onToggleAll: () {
              final ids = grouped[module]!
                  .map((permission) => permission.id)
                  .toList();

              onToggleAll(ids);
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildActions(),
      ],
    );
  }

  Widget _buildActions() {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          TextButton(
            onPressed: isSaving ? null : onCancel,
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: !hasChanges || isSaving ? null : onSave,
            icon: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined, size: 17),
            label: Text(isSaving ? 'Saving...' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
