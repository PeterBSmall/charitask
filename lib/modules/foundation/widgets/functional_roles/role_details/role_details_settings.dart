import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/services/functional_role_service.dart';
import '../../../domain/models/functional_role.dart';
import '../../../domain/models/functional_role_category.dart';
import '../../../../../platform/authorization/authorization.dart'
    hide FunctionalRole, Permission;

import 'settings/role_settings_category.dart';
import 'settings/role_settings_danger_zone.dart';
import 'settings/role_settings_identity.dart';
import 'settings/role_settings_information.dart';
import 'settings/role_settings_status.dart';

class RoleDetailsSettings extends StatefulWidget {
  final String organizationId;
  final FunctionalRole role;

  final VoidCallback? onRoleArchived;
  final VoidCallback? onRoleRestored;
  final VoidCallback? onRoleDeleted;

  const RoleDetailsSettings({
    super.key,
    required this.organizationId,
    required this.role,
    this.onRoleArchived,
    this.onRoleRestored,
    this.onRoleDeleted,
  });

  @override
  State<RoleDetailsSettings> createState() => _RoleDetailsSettingsState();
}

class _RoleDetailsSettingsState extends State<RoleDetailsSettings> {
  final _service = FunctionalRoleService();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<FunctionalRoleCategory> _categories = [];
  String? _selectedCategoryId;

  bool _loading = true;
  bool _saving = false;
  bool _archiving = false;
  bool _restoring = false;
  bool _deleting = false;

  bool _canManage = false;
  bool _canDelete = false;

  String? _error;

  bool get _isSystemRole => widget.role.isImported;

  @override
  void initState() {
    super.initState();
    _syncFromRole();
    _load();
  }

  @override
  void didUpdateWidget(covariant RoleDetailsSettings oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.role.id != widget.role.id) {
      _syncFromRole();
      _load();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _syncFromRole() {
    _nameController.text = widget.role.name;
    _descriptionController.text = widget.role.description ?? '';
    _selectedCategoryId = widget.role.categoryId;
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authorization = AuthorizationService(Supabase.instance.client);

      final results = await Future.wait([
        _service.getCategories(organizationId: widget.organizationId),
        authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'functionalrole.manage',
        ),
        authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'functionalrole.delete',
        ),
      ]);

      if (!mounted) return;

      setState(() {
        _categories = results[0] as List<FunctionalRoleCategory>;
        _canManage = results[1] as bool;
        _canDelete = results[2] as bool;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Unable to load role settings.';
      });
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (!_isSystemRole && name.isEmpty) {
      _showMessage('Role name is required.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final changes = <String, dynamic>{
        'description': description.isEmpty ? null : description,
      };

      if (!_isSystemRole) {
        changes['name'] = name;
        changes['category_id'] = _selectedCategoryId;
      }

      final updated = await _service.updateRole(
        organizationId: widget.organizationId,
        roleId: widget.role.id,
        changes: changes,
      );

      if (!mounted) return;

      setState(() {
        _saving = false;
        _nameController.text = updated.name;
        _descriptionController.text = updated.description ?? '';
        _selectedCategoryId = updated.categoryId;
      });

      _showMessage('Role settings saved.');
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      _showMessage('Unable to save role settings.');
    }
  }

  Future<void> _archiveRole() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Archive Role?'),
          content: Text(
            'Archiving "${widget.role.name}" will make this role inactive '
            'and remove it from the active role list.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB91C1C),
              ),
              child: const Text('Archive Role'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _archiving = true;
    });

    try {
      await _service.archiveRole(
        organizationId: widget.organizationId,
        roleId: widget.role.id,
      );

      if (!mounted) return;

      setState(() {
        _archiving = false;
      });

      _showMessage('Role archived.');

      widget.onRoleArchived?.call();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _archiving = false;
      });

      _showMessage('Unable to archive this role.');
    }
  }

  Future<void> _restoreRole() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restore Role?'),
          content: Text(
            'Restore "${widget.role.name}" and make it active again? '
            'The role will become available for assignments.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Restore Role'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _restoring = true;
    });

    try {
      await _service.restoreRole(
        organizationId: widget.organizationId,
        roleId: widget.role.id,
      );

      if (!mounted) return;

      setState(() {
        _restoring = false;
      });

      _showMessage('Role restored.');

      widget.onRoleRestored?.call();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _restoring = false;
      });

      _showMessage('Unable to restore this role.');
    }
  }

  Future<void> _deleteRole() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permanently Delete Role?'),
          content: Text(
            'This will permanently delete "${widget.role.name}". '
            'This action cannot be undone.\n\n'
            'Are you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB91C1C),
              ),
              child: const Text('Delete Permanently'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _deleting = true;
    });

    try {
      await _service.deleteRole(
        organizationId: widget.organizationId,
        roleId: widget.role.id,
      );

      if (!mounted) return;

      setState(() {
        _deleting = false;
      });

      _showMessage('Role permanently deleted.');

      widget.onRoleDeleted?.call();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _deleting = false;
      });

      _showMessage(
        'Unable to delete this role. It may still have associated records.',
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoleSettingsIdentity(role: widget.role),
        const SizedBox(height: 16),

        RoleSettingsInformation(
          role: widget.role,
          nameController: _nameController,
          descriptionController: _descriptionController,
          canManage: _canManage,
          loading: _loading,
          saving: _saving,
          error: _error,
          onRetry: _load,
          onSave: _save,
        ),
        const SizedBox(height: 16),

        RoleSettingsCategory(
          role: widget.role,
          categories: _categories,
          selectedCategoryId: _selectedCategoryId,
          canManage: _canManage,
          saving: _saving,
          loading: _loading,
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
            });
          },
        ),
        const SizedBox(height: 16),

        RoleSettingsStatus(role: widget.role),
        const SizedBox(height: 16),

        if (_canManage && !_isSystemRole)
          RoleSettingsDangerZone(
            active: widget.role.isActive,
            archiving: _archiving,
            restoring: _restoring,
            deleting: _deleting,
            canDelete: _canDelete,
            onArchive: _archiveRole,
            onRestore: _restoreRole,
            onDelete: _deleteRole,
          ),
      ],
    );
  }
}
