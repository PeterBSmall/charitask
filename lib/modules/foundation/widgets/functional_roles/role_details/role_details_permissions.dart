import 'package:flutter/material.dart';

import '../../../data/services/functional_role_service.dart';
import '../../../domain/models/functional_role.dart';
import '../../../domain/models/permission.dart';

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

  bool _isLoading = true;
  String? _errorMessage;

  List<Permission> _permissions = [];
  Set<String> _assignedPermissionIds = {};

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
    });

    try {
      final allPermissionsFuture = _service.getPermissions();
      final rolePermissionsFuture = _service.getRolePermissions(
        organizationId: widget.organizationId,
        roleId: widget.role.id,
      );

      final allPermissions = await allPermissionsFuture;
      final rolePermissions = await rolePermissionsFuture;

      if (!mounted) return;

      setState(() {
        _permissions = allPermissions;
        _assignedPermissionIds = rolePermissions
            .map((permission) => permission.id)
            .toSet();
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

    final grouped = <String, List<Permission>>{};

    for (final permission in _permissions) {
      grouped.putIfAbsent(permission.module, () => []).add(permission);
    }

    final assignedCount = _assignedPermissionIds.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSummary(assignedCount),
        const SizedBox(height: 20),
        ...grouped.entries.map(
          (entry) => _buildModule(_moduleName(entry.key), entry.value),
        ),
      ],
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
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 20, color: Color(0xFF5B3FD3)),
          const SizedBox(width: 10),
          Text(
            '$assignedCount assigned',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'of ${_permissions.length} available',
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildModule(String name, List<Permission> permissions) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
              ),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            ...permissions.map(_buildPermission),
          ],
        ),
      ),
    );
  }

  Widget _buildPermission(Permission permission) {
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
                if (permission.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    permission.description!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
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
            : '${module[0].toUpperCase()}${module.substring(1)}';
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
