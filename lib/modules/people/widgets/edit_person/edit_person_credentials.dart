import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/data/services/person_credential_document_service.dart';
import 'package:charitask/modules/people/data/services/person_credential_service.dart';
import 'package:charitask/modules/people/domain/models/functional_role_credential_requirement.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/services/credential_compliance_evaluator.dart';
import 'package:charitask/modules/people/widgets/add_person/credential_entry_dialog.dart';
import 'package:charitask/platform/authorization/authorization_service.dart';

class EditPersonCredentials extends StatefulWidget {
  const EditPersonCredentials({
    super.key,
    required this.organizationId,
    required this.personId,
    this.initialRequirementAssessment,
  });

  final String organizationId;
  final String personId;
  final CredentialRequirementAssessment? initialRequirementAssessment;

  @override
  State<EditPersonCredentials> createState() => _EditPersonCredentialsState();
}

class _EditPersonCredentialsState extends State<EditPersonCredentials> {
  static const _cyan = Color(0xFF0891B2);
  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _purple = Color(0xFF5B4BC4);

  late final PersonCredentialService _credentialService;
  late final PersonCredentialDocumentService _documentService;
  late final AuthorizationService _authorization;

  List<PersonCredential> _credentials = [];

  bool _isLoading = true;
  bool _isSaving = false;
  bool _canViewCredentials = false;
  bool _canManageCredentials = false;
  bool _canViewBackgroundChecks = false;
  bool _canManageBackgroundChecks = false;

  String? _errorMessage;
  bool _initialRequirementHandled = false;

  @override
  void initState() {
    super.initState();

    final supabase = Supabase.instance.client;

    _credentialService = PersonCredentialService(supabase: supabase);
    _documentService = PersonCredentialDocumentService(supabase: supabase);
    _authorization = AuthorizationService(supabase);

    _loadCredentials();
  }

  Future<bool> _hasPermission(String key) {
    return _authorization.hasPermission(
      organizationId: widget.organizationId,
      permissionKey: key,
    );
  }

  Future<void> _loadCredentials({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final permissions = await Future.wait<bool>([
        _hasPermission('credentials.view'),
        _hasPermission('credentials.manage'),
        _hasPermission('credentials.background_checks.view'),
        _hasPermission('credentials.background_checks.manage'),
      ]);

      final canViewCredentials = permissions[0];
      final canManageCredentials = permissions[1];
      final canViewBackgroundChecks = permissions[2];
      final canManageBackgroundChecks = permissions[3];

      if (!canViewCredentials && !canViewBackgroundChecks) {
        if (!mounted) return;

        setState(() {
          _canViewCredentials = false;
          _canManageCredentials = canManageCredentials;
          _canViewBackgroundChecks = false;
          _canManageBackgroundChecks = canManageBackgroundChecks;
          _credentials = [];
          _isLoading = false;
          _errorMessage = null;
        });
        _scheduleInitialRequirementHandling();
        return;
      }

      final loaded = await _credentialService.getPersonCredentials(
        organizationId: widget.organizationId,
        personId: widget.personId,
      );

      // Keep background-check records hidden unless specifically authorized.
      final visible = loaded.where((credential) {
        if (credential.category.isBackgroundCheck) {
          return canViewBackgroundChecks;
        }
        return canViewCredentials;
      }).toList();

      if (!mounted) return;

      setState(() {
        _canViewCredentials = canViewCredentials;
        _canManageCredentials = canManageCredentials;
        _canViewBackgroundChecks = canViewBackgroundChecks;
        _canManageBackgroundChecks = canManageBackgroundChecks;
        _credentials = visible;
        _isLoading = false;
        _errorMessage = null;
      });
      _scheduleInitialRequirementHandling();
    } catch (error) {
      debugPrint('Loading person credentials failed: $error');

      if (!mounted) return;

      setState(() {
        _credentials = [];
        _isLoading = false;
        _errorMessage =
            'Credentials could not be loaded. Check your permissions '
            'and try again.';
      });
    }
  }

  void _scheduleInitialRequirementHandling() {
    if (_initialRequirementHandled ||
        widget.initialRequirementAssessment == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _initialRequirementHandled) return;
      _initialRequirementHandled = true;
      _handleInitialRequirement(widget.initialRequirementAssessment!);
    });
  }

  Future<void> _handleInitialRequirement(
    CredentialRequirementAssessment assessment,
  ) async {
    if (assessment.status == CredentialRequirementItemStatus.accessRestricted) {
      _showMessage(
        'You do not have permission to manage this credential requirement.',
      );
      return;
    }

    final category = assessment.requirement.category;
    if (!_canManageCategory(category)) {
      _showMessage(
        'You do not have permission to manage this credential category.',
      );
      return;
    }

    final existing = assessment.matchingCredential;
    if (existing != null) {
      await _editCredential(existing, requirement: assessment.requirement);
    } else {
      await _addCredential(requirement: assessment.requirement);
    }
  }

  List<CredentialCategory> get _allowedCategories {
    return CredentialCategory.values.where((category) {
      if (category.isBackgroundCheck) {
        return _canViewBackgroundChecks && _canManageBackgroundChecks;
      }

      return _canViewCredentials && _canManageCredentials;
    }).toList();
  }

  bool _canManageCategory(CredentialCategory category) {
    if (category.isBackgroundCheck) {
      return _canViewBackgroundChecks && _canManageBackgroundChecks;
    }

    return _canViewCredentials && _canManageCredentials;
  }

  Future<void> _addCredential({
    FunctionalRoleCredentialRequirement? requirement,
  }) async {
    final allowedCategories = requirement == null
        ? _allowedCategories
        : _allowedCategories
              .where((category) => category == requirement.category)
              .toList();
    if (_isSaving || allowedCategories.isEmpty) {
      if (requirement != null && mounted) {
        _showMessage(
          'You do not have permission to add the required credential.',
        );
      }
      return;
    }

    final draft = await showDialog<PersonCredentialDraft>(
      context: context,
      builder: (_) => CredentialEntryDialog(
        allowedCategories: allowedCategories,
        lockCategory: requirement != null,
        initialCredentialName: requirement?.credentialName,
        lockCredentialName:
            requirement?.credentialName?.trim().isNotEmpty == true,
      ),
    );

    if (draft == null || !mounted) return;

    if (!_canManageCategory(draft.category)) {
      _showMessage('You do not have permission to add this credential.');
      return;
    }

    setState(() => _isSaving = true);

    var documentUploadFailed = false;

    try {
      final saved = await _credentialService.createCredential(
        organizationId: widget.organizationId,
        personId: widget.personId,
        credential: draft,
      );

      if (draft.documents.isNotEmpty) {
        try {
          await _documentService.uploadDocuments(
            organizationId: widget.organizationId,
            personId: widget.personId,
            credentialId: saved.id,
            category: saved.category,
            documents: draft.documents,
          );
        } catch (error) {
          debugPrint('Credential document upload failed: $error');
          documentUploadFailed = true;
        }
      }

      await _loadCredentials(showLoading: false);

      if (!mounted) return;

      _showMessage(
        documentUploadFailed
            ? 'Credential saved, but some supporting files could not '
                  'be uploaded.'
            : 'Credential added.',
      );
    } catch (error) {
      debugPrint('Adding credential failed: $error');

      if (mounted) {
        _showMessage('Unable to add the credential. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _editCredential(
    PersonCredential credential, {
    FunctionalRoleCredentialRequirement? requirement,
  }) async {
    if (_isSaving || !_canManageCategory(credential.category)) return;

    final draft = await showDialog<PersonCredentialDraft>(
      context: context,
      builder: (_) => CredentialEntryDialog(
        initialCredential: credential.toDraft(),
        allowedCategories: [credential.category],
        lockCategory: true,
        initialCredentialName: requirement?.credentialName,
        lockCredentialName:
            requirement?.credentialName?.trim().isNotEmpty == true,
      ),
    );

    if (draft == null || !mounted) return;

    setState(() => _isSaving = true);

    var documentUploadFailed = false;

    try {
      await _credentialService.updateCredential(
        organizationId: widget.organizationId,
        personId: widget.personId,
        credentialId: credential.id,
        credential: draft,
      );

      // Existing attachments are preserved. Only newly selected files
      // are uploaded during this edit.
      if (draft.documents.isNotEmpty) {
        try {
          await _documentService.uploadDocuments(
            organizationId: widget.organizationId,
            personId: widget.personId,
            credentialId: credential.id,
            category: credential.category,
            documents: draft.documents,
          );
        } catch (error) {
          debugPrint('Credential document upload failed: $error');
          documentUploadFailed = true;
        }
      }

      await _loadCredentials(showLoading: false);

      if (!mounted) return;

      _showMessage(
        documentUploadFailed
            ? 'Credential updated, but some new supporting files '
                  'could not be uploaded.'
            : 'Credential updated.',
      );
    } catch (error) {
      debugPrint('Updating credential failed: $error');

      if (mounted) {
        _showMessage('Unable to update the credential. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _deleteCredential(PersonCredential credential) async {
    if (_isSaving || !_canManageCategory(credential.category)) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Credential?'),
        content: Text(
          'Delete "${credential.credentialName}" from this person? '
          'This action cannot be undone.',
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
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSaving = true);

    var cleanupFailed = false;

    try {
      // Collect storage paths before deleting document metadata.
      final storagePaths = await _documentService.getStoragePathsForCredential(
        organizationId: widget.organizationId,
        personId: widget.personId,
        credentialId: credential.id,
      );

      // Delete document metadata first to satisfy the foreign key.
      await _documentService.deleteDocumentMetadataForCredential(
        organizationId: widget.organizationId,
        personId: widget.personId,
        credentialId: credential.id,
      );

      // Now delete the credential record.
      await _credentialService.deleteCredential(
        organizationId: widget.organizationId,
        personId: widget.personId,
        credentialId: credential.id,
      );

      // Remove the files from storage after the database deletions succeed.
      try {
        await _documentService.removeStorageObjects(storagePaths);
      } catch (error) {
        debugPrint('Credential file cleanup failed: $error');
        cleanupFailed = true;
      }

      await _loadCredentials(showLoading: false);

      if (!mounted) return;

      _showMessage(
        cleanupFailed
            ? 'Credential deleted, but some supporting files may need '
                  'cleanup.'
            : 'Credential deleted.',
      );
    } catch (error) {
      debugPrint('Deleting credential failed: $error');

      if (mounted) {
        _showMessage('Unable to delete the credential. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _statusLabel(PersonCredential credential) {
    if (credential.isExpired) return 'Expired';

    if (credential.status.isSuccessful && credential.isExpiringSoon()) {
      return 'Expiring Soon';
    }

    return credential.status.label;
  }

  Color _statusColor(PersonCredential credential) {
    if (credential.isExpired ||
        credential.status == CredentialStatus.rejected ||
        credential.status == CredentialStatus.notCleared) {
      return const Color(0xFFB91C1C);
    }

    if (credential.status.isSuccessful && credential.isExpiringSoon()) {
      return const Color(0xFFB45309);
    }

    if (credential.status.isSuccessful) {
      return const Color(0xFF047857);
    }

    return const Color(0xFFB45309);
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCredentialTile(PersonCredential credential) {
    final statusColor = _statusColor(credential);
    final canManage = _canManageCategory(credential.category);

    final dates = <String>[
      if (credential.issueDate != null)
        'Issued ${_formatDate(credential.issueDate)}',
      if (credential.expirationDate != null)
        '${credential.isExpired ? 'Expired' : 'Expires'} '
            '${_formatDate(credential.expirationDate)}',
    ];

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _badge(credential.category.label, _cyan),
              _badge(_statusLabel(credential), statusColor),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            credential.credentialName,
            style: const TextStyle(
              color: _navy,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          if (credential.issuingOrganization?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              credential.issuingOrganization!,
              style: const TextStyle(color: _muted, fontSize: 13),
            ),
          ],
          if (dates.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: dates
                  .map(
                    (date) => Text(
                      date,
                      style: TextStyle(
                        color:
                            credential.isExpired && date.startsWith('Expired')
                            ? const Color(0xFFB91C1C)
                            : _muted,
                        fontSize: 12,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (canManage) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 8,
                children: [
                  TextButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () => _editCredential(credential),
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text('Edit'),
                  ),
                  TextButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () => _deleteCredential(credential),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 17,
                      color: Color(0xFFB91C1C),
                    ),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: Color(0xFFB91C1C)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allowedCategories = _allowedCategories;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFCFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB6E3EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium_outlined,
                  color: _cyan,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Credentials & Compliance',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Manage certifications, licenses, training, '
                      'and authorized compliance records.',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (_canViewCredentials || _canViewBackgroundChecks)
            if (allowedCategories.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: _isSaving ? null : _addCredential,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Credential'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _cyan,
                    side: const BorderSide(color: _cyan),
                  ),
                ),
              ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_errorMessage != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Color(0xFFB91C1C)),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _isSaving ? null : _loadCredentials,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            )
          else if (!_canViewCredentials && !_canViewBackgroundChecks)
            const Text(
              'You do not have permission to view credentials for this person.',
              style: TextStyle(color: _muted, height: 1.5),
            )
          else if (_credentials.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 32,
                      color: Color(0xFF94A3B8),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No credentials added',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _navy,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Add qualifications or compliance records relevant '
                      'to this person.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._credentials.map(_buildCredentialTile),
          if (_isSaving) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(color: _purple),
          ],
          if (_credentials.any(
            (credential) =>
                credential.category == CredentialCategory.backgroundCheck,
          )) ...[
            const SizedBox(height: 14),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline, size: 17, color: _muted),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Record background-check status and relevant dates only. '
                    'Do not enter sensitive report details here.',
                    style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
