import 'package:flutter/material.dart';

import '../../../../domain/models/functional_role.dart';
import 'role_settings_widgets.dart';

class RoleSettingsInformation extends StatelessWidget {
  final FunctionalRole role;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool canManage;
  final bool loading;
  final bool saving;
  final String? error;
  final VoidCallback onRetry;
  final VoidCallback onSave;

  const RoleSettingsInformation({
    super.key,
    required this.role,
    required this.nameController,
    required this.descriptionController,
    required this.canManage,
    required this.loading,
    required this.saving,
    required this.error,
    required this.onRetry,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isSystemRole = role.isImported;

    return RoleSettingsCard(
      title: 'Role Information',
      subtitle: 'Update the basic information for this functional role.',
      child: _buildContent(isSystemRole),
    );
  }

  Widget _buildContent(bool isSystemRole) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            error!,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_outlined, size: 17),
            label: const Text('Try Again'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoleSettingsFieldLabel(
          label: 'Role Name',
          helperText: isSystemRole
              ? 'System role names are managed by ChariTask.'
              : null,
          child: TextField(
            controller: nameController,
            enabled: canManage && !saving && !isSystemRole,
            decoration: roleSettingsInputDecoration(
              hintText: 'Enter role name',
              suffixIcon: isSystemRole
                  ? const Icon(Icons.lock_outline, size: 18)
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 16),
        RoleSettingsFieldLabel(
          label: 'Description',
          child: TextField(
            controller: descriptionController,
            enabled: canManage && !saving,
            minLines: 3,
            maxLines: 5,
            decoration: roleSettingsInputDecoration(
              hintText: 'Describe the responsibilities of this role',
            ),
          ),
        ),
        if (canManage) ...[
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: saving ? null : onSave,
              icon: saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined, size: 17),
              label: Text(saving ? 'Saving...' : 'Save Changes'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5B3FD3),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
