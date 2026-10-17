import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role_assignment.dart';
import 'package:charitask/modules/people/widgets/edit_person/edit_person_assignments.dart';

class EditPersonFunctionalRolesPanel extends StatefulWidget {
  const EditPersonFunctionalRolesPanel({
    super.key,
    required this.organizationId,
    required this.personId,
    required this.canManage,
  });

  final String organizationId;
  final String personId;
  final bool canManage;

  @override
  State<EditPersonFunctionalRolesPanel> createState() =>
      _EditPersonFunctionalRolesPanelState();
}

class _EditPersonFunctionalRolesPanelState
    extends State<EditPersonFunctionalRolesPanel> {
  late final FunctionalRoleService _service;

  bool _isLoading = true;
  String? _loadError;

  List<FunctionalRole> _roles = [];
  List<FunctionalRoleAssignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _service = FunctionalRoleService(supabase: Supabase.instance.client);
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _loadData();
    } catch (error) {
      debugPrint('Functional role loading failed: $error');
      _loadError = 'Functional roles could not be loaded. Please try again.';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadData() async {
    final roles = await _service.getRoles(
      organizationId: widget.organizationId,
      activeOnly: false,
    );

    final assignments = await _service.getAssignments(
      organizationId: widget.organizationId,
      personId: widget.personId,
      activeOnly: true,
    );

    _roles = roles;
    _assignments = assignments;
    _loadError = null;
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      await _loadData();
    } catch (error) {
      debugPrint('Functional role refresh failed: $error');
      _loadError = 'Functional roles could not be refreshed. Please try again.';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, FunctionalRole> get _rolesById => {
    for (final role in _roles) role.id: role,
  };

  List<EditPersonRoleOption> get _availableRoleOptions {
    final assignedIds = _assignments
        .where((assignment) => assignment.isActive)
        .map((assignment) => assignment.functionalRoleId)
        .toSet();

    return _roles
        .where((role) => role.isActive && !assignedIds.contains(role.id))
        .map(
          (role) => EditPersonRoleOption(
            id: role.id,
            name: role.name,
            categoryName: role.categoryName,
          ),
        )
        .toList();
  }

  List<EditPersonRoleAssignment> get _assignmentItems {
    final roles = _rolesById;

    return _assignments
        .where((assignment) => assignment.isActive)
        .map(
          (assignment) => EditPersonRoleAssignment(
            id: assignment.id,
            roleName:
                roles[assignment.functionalRoleId]?.name ?? 'Unavailable role',
            assignedAt: assignment.assignedAt,
          ),
        )
        .toList();
  }

  Future<void> _assignRole(String roleId) async {
    if (!widget.canManage) return;

    try {
      await _service.createAssignment(
        organizationId: widget.organizationId,
        personId: widget.personId,
        functionalRoleId: roleId,
      );

      await _refreshData();
      _showMessage('Functional role assigned.');
    } catch (error) {
      debugPrint('Functional role assignment failed: $error');
      _showMessage('Unable to assign this role. Please try again.');
    }
  }

  Future<void> _endRoleAssignment(String assignmentId) async {
    if (!widget.canManage) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('End role assignment?'),
        content: const Text(
          'This will end the person’s current assignment to this role.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('End Assignment'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _service.endAssignment(
        organizationId: widget.organizationId,
        assignmentId: assignmentId,
      );

      await _refreshData();
      _showMessage('Role assignment ended.');
    } catch (error) {
      debugPrint('Ending role assignment failed: $error');
      _showMessage('Unable to end this assignment. Please try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_loadError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_loadError!),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      );
    }

    return EditPersonAssignments(
      assignments: _assignmentItems,
      availableRoles: _availableRoleOptions,
      canManage: widget.canManage,
      onAssignRole: _assignRole,
      onEndAssignment: _endRoleAssignment,
    );
  }
}
