import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/people/data/services/functional_role_credential_requirement_service.dart';
import 'package:charitask/modules/people/domain/models/functional_role_credential_requirement.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/platform/authorization/authorization_service.dart';

import 'role_settings_widgets.dart';

class RoleSettingsCredentialRequirements extends StatefulWidget {
  const RoleSettingsCredentialRequirements({
    super.key,
    required this.organizationId,
    required this.role,
  });

  final String organizationId;
  final FunctionalRole role;

  @override
  State<RoleSettingsCredentialRequirements> createState() =>
      _RoleSettingsCredentialRequirementsState();
}

class _RoleSettingsCredentialRequirementsState
    extends State<RoleSettingsCredentialRequirements> {
  final _service = FunctionalRoleCredentialRequirementService();

  List<FunctionalRoleCredentialRequirement> _requirements = [];

  bool _loading = true;
  bool _canView = false;
  bool _canManage = false;
  String? _error;
  String? _busyRequirementId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant RoleSettingsCredentialRequirements oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.organizationId != widget.organizationId ||
        oldWidget.role.id != widget.role.id) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authorization = AuthorizationService(Supabase.instance.client);

      final permissions = await Future.wait([
        authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'functionalrole.view',
        ),
        authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'functionalrole.edit',
        ),
      ]);

      final canView = permissions[0];
      final canManage = permissions[1];

      if (!canView) {
        if (!mounted) return;

        setState(() {
          _canView = false;
          _canManage = false;
          _requirements = [];
          _loading = false;
        });
        return;
      }

      final requirements = await _service.getForRole(
        organizationId: widget.organizationId,
        functionalRoleId: widget.role.id,
      );

      if (!mounted) return;

      setState(() {
        _canView = true;
        _canManage = canManage;
        _requirements = requirements;
        _loading = false;
      });
    } catch (error) {
      debugPrint('Credential requirement load failed: $error');

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Unable to load credential requirements.';
      });
    }
  }

  Future<void> _openEditor({
    FunctionalRoleCredentialRequirement? requirement,
  }) async {
    final nameController = TextEditingController(
      text: requirement?.credentialName ?? '',
    );
    final descriptionController = TextEditingController(
      text: requirement?.description ?? '',
    );

    var selectedCategory =
        requirement?.category ?? CredentialCategory.certification;

    final formKey = GlobalKey<FormState>();

    try {
      final draft = await showDialog<_RequirementDraft>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(
                  requirement == null
                      ? 'Add Credential Requirement'
                      : 'Edit Credential Requirement',
                ),
                content: SizedBox(
                  width: 440,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Define what a person assigned this role '
                            'must provide.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<CredentialCategory>(
                            initialValue: selectedCategory,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Credential Category',
                              border: OutlineInputBorder(),
                            ),
                            items: CredentialCategory.values.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category.label),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value == null) return;

                              setDialogState(() {
                                selectedCategory = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Credential Name (Optional)',
                              hintText: 'e.g. Driver License',
                              border: OutlineInputBorder(),
                              helperText:
                                  'Leave blank to accept any credential '
                                  'in this category.',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: descriptionController,
                            minLines: 2,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Instructions (Optional)',
                              hintText: 'Explain what is required.',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;

                      Navigator.of(dialogContext).pop(
                        _RequirementDraft(
                          category: selectedCategory,
                          credentialName: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                        ),
                      );
                    },
                    child: Text(
                      requirement == null ? 'Add Requirement' : 'Save Changes',
                    ),
                  ),
                ],
              );
            },
          );
        },
      );

      if (draft == null || !mounted) return;

      setState(() {
        _saving = true;
      });

      if (requirement == null) {
        await _service.create(
          organizationId: widget.organizationId,
          functionalRoleId: widget.role.id,
          category: draft.category,
          credentialName: draft.credentialName,
          description: draft.description,
        );
      } else {
        await _service.update(
          organizationId: widget.organizationId,
          functionalRoleId: widget.role.id,
          requirementId: requirement.id,
          category: draft.category,
          credentialName: draft.credentialName,
          description: draft.description,
        );
      }

      if (!mounted) return;

      await _load();
      _showMessage(
        requirement == null
            ? 'Credential requirement added.'
            : 'Credential requirement updated.',
      );
    } catch (error) {
      debugPrint('Credential requirement save failed: $error');

      if (mounted) {
        _showMessage(
          'Unable to save the requirement. Check your permissions '
          'and try again.',
        );
      }
    } finally {
      nameController.dispose();
      descriptionController.dispose();

      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _deleteRequirement(
    FunctionalRoleCredentialRequirement requirement,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Requirement?'),
          content: Text(
            'Remove the ${requirement.category.label.toLowerCase()} '
            'requirement from "${widget.role.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB91C1C),
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _busyRequirementId = requirement.id;
    });

    try {
      await _service.delete(
        organizationId: widget.organizationId,
        functionalRoleId: widget.role.id,
        requirementId: requirement.id,
      );

      if (!mounted) return;

      await _load();
      _showMessage('Credential requirement removed.');
    } catch (error) {
      debugPrint('Credential requirement removal failed: $error');

      if (mounted) {
        _showMessage('Unable to remove this requirement.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _busyRequirementId = null;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return RoleSettingsCard(
      title: 'Credential Requirements',
      subtitle: 'Define credentials needed by people assigned to this role.',
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _error!,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh_outlined),
            label: const Text('Try Again'),
          ),
        ],
      );
    }

    if (!_canView) {
      return const Text(
        'You do not have permission to view this role’s credential '
        'requirements.',
        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_requirements.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Text(
              'No credential requirements configured for this role. '
              'People assigned to this role will not be marked as missing '
              'credentials until requirements are added.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF64748B),
              ),
            ),
          )
        else
          ..._requirements.map(_buildRequirementRow),
        if (_canManage) ...[
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: _saving ? null : () => _openEditor(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Requirement'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5B3FD3),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRequirementRow(FunctionalRoleCredentialRequirement requirement) {
    final name = requirement.credentialName?.trim();
    final hasName = name != null && name.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.workspace_premium_outlined,
            size: 21,
            color: Color(0xFF5B3FD3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasName ? name : 'Any ${requirement.category.label}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  requirement.category.label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                if (requirement.description?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    requirement.description!.trim(),
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_canManage) ...[
            IconButton(
              tooltip: 'Edit requirement',
              visualDensity: VisualDensity.compact,
              onPressed: _saving || _busyRequirementId != null
                  ? null
                  : () => _openEditor(requirement: requirement),
              icon: const Icon(
                Icons.edit_outlined,
                size: 19,
                color: Color(0xFF5B3FD3),
              ),
            ),
            IconButton(
              tooltip: 'Remove requirement',
              visualDensity: VisualDensity.compact,
              onPressed: _saving || _busyRequirementId != null
                  ? null
                  : () => _deleteRequirement(requirement),
              icon: Icon(
                Icons.delete_outline,
                size: 19,
                color: _busyRequirementId == requirement.id
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFFB91C1C),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RequirementDraft {
  const _RequirementDraft({
    required this.category,
    required this.credentialName,
    required this.description,
  });

  final CredentialCategory category;
  final String credentialName;
  final String description;
}
