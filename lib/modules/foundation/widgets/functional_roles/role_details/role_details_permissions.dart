import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/services/functional_role_service.dart';
import '../../../domain/models/functional_role.dart';
import '../../../domain/models/permission.dart';
import '../../../../../platform/authorization/authorization.dart'
    hide FunctionalRole, Permission;
import 'permissions/permission_dependencies.dart';
import 'permissions/permissions_editor.dart';

class RoleDetailsPermissions extends StatefulWidget {
  final String organizationId;
  final FunctionalRole role;

  const RoleDetailsPermissions({
    super.key,
    required this.organizationId,
    required this.role,
  });

  @override
  State<RoleDetailsPermissions> createState() => _RoleDetailsPermissionsState();
}

class _RoleDetailsPermissionsState extends State<RoleDetailsPermissions> {
  final _service = FunctionalRoleService();

  final _authorizationService = AuthorizationService(Supabase.instance.client);

  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _canManage = false;
  bool _hasChanges = false;

  String? _errorMessage;
  String? _saveErrorMessage;

  List<Permission> _permissions = [];
  Set<String> _assignedPermissionIds = {};
  Set<String> _pendingPermissionIds = {};

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  @override
  void didUpdateWidget(covariant RoleDetailsPermissions oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.role.id != widget.role.id ||
        oldWidget.organizationId != widget.organizationId) {
      _loadPermissions();
    }
  }

  Future<void> _loadPermissions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _saveErrorMessage = null;
      _isEditing = false;
      _hasChanges = false;
    });

    try {
      final results = await Future.wait([
        _service.getPermissions(),
        _service.getRolePermissions(
          organizationId: widget.organizationId,
          roleId: widget.role.id,
        ),
        _authorizationService.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'functionalrole.manage',
        ),
      ]);

      final allPermissions = results[0] as List<Permission>;
      final rolePermissions = results[1] as List<Permission>;
      final canManage = results[2] as bool;

      if (!mounted) return;

      final assignedIds = rolePermissions
          .map((permission) => permission.id)
          .toSet();

      setState(() {
        _permissions = allPermissions;
        _assignedPermissionIds = assignedIds;
        _pendingPermissionIds = {...assignedIds};
        _canManage = canManage;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _startEditing() {
    if (!_canManage) return;

    setState(() {
      _pendingPermissionIds = {..._assignedPermissionIds};
      _hasChanges = false;
      _saveErrorMessage = null;
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _pendingPermissionIds = {..._assignedPermissionIds};
      _hasChanges = false;
      _saveErrorMessage = null;
      _isEditing = false;
    });
  }

  Future<void> _togglePermission(String permissionId) async {
    final permission = _permissions.firstWhere(
      (item) => item.id == permissionId,
    );

    final isSelected = _pendingPermissionIds.contains(permissionId);

    if (isSelected) {
      if (PermissionDependencies.actionFor(permission) == 'view') {
        final dependents = PermissionDependencies.findDependents(
          viewPermission: permission,
          permissions: _permissions,
          selectedIds: _pendingPermissionIds,
        );

        if (dependents.isNotEmpty) {
          final confirmed = await _confirmRemoveDependents(dependents);

          if (!confirmed) return;

          setState(() {
            _pendingPermissionIds.removeAll(dependents.map((item) => item.id));
            _pendingPermissionIds.remove(permissionId);
            _updateChangeState();
          });

          return;
        }
      }

      setState(() {
        _pendingPermissionIds.remove(permissionId);
        _updateChangeState();
      });

      return;
    }

    setState(() {
      _pendingPermissionIds.add(permissionId);

      if (PermissionDependencies.requiresView(permission)) {
        final viewPermission = PermissionDependencies.findViewPermission(
          permission: permission,
          permissions: _permissions,
        );

        if (viewPermission != null) {
          _pendingPermissionIds.add(viewPermission.id);
        }
      }

      _updateChangeState();
    });
  }

  void _toggleAll(List<String> permissionIds) {
    final allSelected = permissionIds.every(_pendingPermissionIds.contains);

    setState(() {
      if (allSelected) {
        _pendingPermissionIds.removeAll(permissionIds);
      } else {
        _pendingPermissionIds.addAll(permissionIds);

        for (final permission in _permissions) {
          if (!permissionIds.contains(permission.id)) {
            continue;
          }

          if (PermissionDependencies.requiresView(permission)) {
            final viewPermission = PermissionDependencies.findViewPermission(
              permission: permission,
              permissions: _permissions,
            );

            if (viewPermission != null) {
              _pendingPermissionIds.add(viewPermission.id);
            }
          }
        }
      }

      _updateChangeState();
    });
  }

  void _updateChangeState() {
    _hasChanges = !_setEquals(_assignedPermissionIds, _pendingPermissionIds);
  }

  bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  Future<bool> _confirmRemoveDependents(List<Permission> dependents) async {
    final names = dependents.map((permission) => permission.name).join(', ');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove View permission?'),
        content: Text(
          'Removing View will also remove these permissions:\n\n'
          '$names',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _savePermissions() async {
    if (!_hasChanges || _isSaving) return;

    setState(() {
      _isSaving = true;
      _saveErrorMessage = null;
    });

    try {
      await _service.updateRolePermissions(
        organizationId: widget.organizationId,
        roleId: widget.role.id,
        permissionIds: _pendingPermissionIds,
      );

      if (!mounted) return;

      setState(() {
        _assignedPermissionIds = {..._pendingPermissionIds};
        _hasChanges = false;
        _isEditing = false;
        _isSaving = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _saveErrorMessage = error.toString();
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Card(title: 'Permissions', child: _buildContent());
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return _buildError();
    }

    if (_permissions.isEmpty) {
      return const Text(
        'No permissions are available.',
        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
      );
    }

    if (_isEditing) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_saveErrorMessage != null) ...[
            _buildSaveError(),
            const SizedBox(height: 12),
          ],
          PermissionsEditor(
            permissions: _permissions,
            selectedPermissionIds: _pendingPermissionIds,
            isSaving: _isSaving,
            hasChanges: _hasChanges,
            onToggle: _togglePermission,
            onToggleAll: _toggleAll,
            onCancel: _cancelEditing,
            onSave: _savePermissions,
          ),
        ],
      );
    }

    return _buildReadOnly();
  }

  Widget _buildSaveError() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, size: 19, color: Color(0xFFB91C1C)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _saveErrorMessage!,
              style: const TextStyle(fontSize: 12, color: Color(0xFF991B1B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnly() {
    final assignedCount = _assignedPermissionIds.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSummary(assignedCount),
        const SizedBox(height: 16),
        if (_canManage)
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: _startEditing,
              icon: const Icon(Icons.edit_outlined, size: 17),
              label: const Text('Edit Permissions'),
            ),
          ),
        if (_canManage) const SizedBox(height: 16),
        ..._buildReadOnlyModules(),
      ],
    );
  }

  List<Widget> _buildReadOnlyModules() {
    final grouped = <String, List<Permission>>{};

    for (final permission in _permissions) {
      grouped.putIfAbsent(permission.module, () => []).add(permission);
    }

    final modules = grouped.keys.toList();

    modules.sort((a, b) {
      const order = [
        'people',
        'locations',
        'groups',
        'tasks',
        'functionalrole',
      ];

      final aIndex = order.indexOf(a);
      final bIndex = order.indexOf(b);

      if (aIndex == -1 && bIndex == -1) {
        return a.compareTo(b);
      }

      if (aIndex == -1) return 1;
      if (bIndex == -1) return -1;

      return aIndex.compareTo(bIndex);
    });

    return modules
        .map(
          (module) =>
              _buildReadOnlyModule(_moduleName(module), grouped[module]!),
        )
        .toList();
  }

  Widget _buildReadOnlyModule(String name, List<Permission> permissions) {
    final assignedCount = permissions
        .where((permission) => _assignedPermissionIds.contains(permission.id))
        .length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                Text(
                  '$assignedCount / ${permissions.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...permissions.map(_buildReadOnlyPermission),
        ],
      ),
    );
  }

  Widget _buildReadOnlyPermission(Permission permission) {
    final assigned = _assignedPermissionIds.contains(permission.id);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Icon(
            assigned ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: assigned ? const Color(0xFF16A34A) : const Color(0xFFCBD5E1),
          ),
          const SizedBox(width: 12),
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
                    permission.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      permission.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
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

  Widget _buildSummary(int assignedCount) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 20, color: Color(0xFF5B3FD3)),
          Text(
            '$assignedCount assigned',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const Text(
            '·',
            style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          ),
          Text(
            '${_permissions.length} available',
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Unable to load permissions.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFB91C1C),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _errorMessage!,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _loadPermissions,
          icon: const Icon(Icons.refresh),
          label: const Text('Try Again'),
        ),
      ],
    );
  }

  String _moduleName(String module) {
    switch (module) {
      case 'functionalrole':
        return 'Functional Roles';
      case 'people':
        return 'People';
      case 'locations':
        return 'Locations';
      case 'groups':
        return 'Groups';
      case 'tasks':
        return 'Tasks';
      default:
        return module.isEmpty
            ? module
            : '${module[0].toUpperCase()}'
                  '${module.substring(1)}';
    }
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
