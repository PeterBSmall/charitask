import 'package:flutter/material.dart';

import 'package:charitask/modules/people/data/services/person_credential_document_service.dart';
import 'package:charitask/modules/people/data/services/compliance_review_service.dart';
import 'package:charitask/modules/people/domain/models/person_credential_document_record.dart';
import 'package:charitask/modules/people/domain/services/credential_compliance_evaluator.dart';

class ComplianceRecordDetailPage extends StatefulWidget {
  const ComplianceRecordDetailPage({
    super.key,
    required this.organizationId,
    required this.personId,
    required this.personName,
    required this.initialRequirementAssessment,
  });

  final String organizationId;
  final String personId;
  final String personName;
  final CredentialRequirementAssessment initialRequirementAssessment;

  @override
  State<ComplianceRecordDetailPage> createState() =>
      _ComplianceRecordDetailPageState();
}

class _ComplianceRecordDetailPageState
    extends State<ComplianceRecordDetailPage> {
  static const _purple = Color(0xFF5B4BC4);
  static const _navy = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  late final PersonCredentialDocumentService _documentService;
  late final ComplianceReviewService _reviewService;

  List<PersonCredentialDocumentRecord> _documents = [];
  bool _isLoadingDocuments = false;
  String? _documentError;

  Map<String, dynamic>? _review;
  List<Map<String, dynamic>> _checklistItems = [];
  List<Map<String, dynamic>> _decisionHistory = [];
  List<Map<String, dynamic>> _auditHistory = [];

  bool _isLoadingReview = false;
  bool _isSavingChecklist = false;
  bool _isSubmittingDecision = false;
  String? _reviewError;
  String? _reviewLoadMessage;

  @override
  void initState() {
    super.initState();
    _documentService = PersonCredentialDocumentService();
    _reviewService = ComplianceReviewService();
    _loadDocuments();
    _loadReview();
  }

  Future<void> _loadDocuments() async {
    final credential = widget.initialRequirementAssessment.matchingCredential;

    if (credential == null) {
      setState(() {
        _documents = [];
        _isLoadingDocuments = false;
        _documentError = null;
      });
      return;
    }

    setState(() {
      _isLoadingDocuments = true;
      _documentError = null;
    });

    try {
      final documents = await _documentService.getDocumentsForCredential(
        organizationId: widget.organizationId,
        personId: widget.personId,
        credentialId: credential.id,
      );

      if (!mounted) return;

      setState(() {
        _documents = documents;
        _isLoadingDocuments = false;
        _documentError = null;
      });
    } catch (error) {
      debugPrint('Loading credential documents failed: $error');

      if (!mounted) return;

      setState(() {
        _documents = [];
        _isLoadingDocuments = false;
        _documentError =
            'Documents could not be loaded. Check access permissions '
            'and try again.';
      });
    }
  }

  Future<void> _loadReview() async {
    final credential = widget.initialRequirementAssessment.matchingCredential;

    if (credential == null) {
      if (!mounted) return;
      setState(() {
        _review = null;
        _checklistItems = [];
        _decisionHistory = [];
        _auditHistory = [];
        _isLoadingReview = false;
        _reviewError = null;
        _reviewLoadMessage =
            'A review will be available after a credential is submitted.';
      });
      return;
    }

    setState(() {
      _isLoadingReview = true;
      _reviewError = null;
      _reviewLoadMessage = null;
    });

    try {
      final reviews = await _reviewService.getReviews(
        organizationId: widget.organizationId,
      );

      final matching = reviews.where(
        (row) =>
            row['person_id']?.toString() == widget.personId &&
            row['credential_id']?.toString() == credential.id,
      );

      if (matching.isEmpty) {
        if (!mounted) return;
        setState(() {
          _review = null;
          _checklistItems = [];
          _decisionHistory = [];
          _auditHistory = [];
          _isLoadingReview = false;
          _reviewLoadMessage =
              'No review has been created for this credential yet.';
        });
        return;
      }

      final review = matching.first;
      final reviewId = review['id']?.toString();

      if (reviewId == null || reviewId.isEmpty) {
        throw StateError('The review record has no ID.');
      }

      final results = await Future.wait([
        _reviewService.getChecklistItems(
          organizationId: widget.organizationId,
          reviewId: reviewId,
        ),
        _reviewService.getDecisionHistory(
          organizationId: widget.organizationId,
          reviewId: reviewId,
        ),
        _reviewService.getAuditHistory(
          organizationId: widget.organizationId,
          reviewId: reviewId,
        ),
      ]);

      if (!mounted) return;

      setState(() {
        _review = review;
        _checklistItems = results[0];
        _decisionHistory = results[1];
        _auditHistory = results[2];
        _isLoadingReview = false;
        _reviewError = null;
        _reviewLoadMessage = null;
      });
    } catch (error) {
      debugPrint('Loading compliance review failed: $error');

      if (!mounted) return;

      setState(() {
        _isLoadingReview = false;
        _reviewError =
            'The review could not be loaded. Check your permissions and retry.';
      });
    }
  }

  Future<void> _viewDocument(PersonCredentialDocumentRecord document) async {
    final credential = widget.initialRequirementAssessment.matchingCredential;
    if (credential == null) return;

    final isImage =
        document.contentType == 'image/jpeg' ||
        document.contentType == 'image/png';

    if (!isImage) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('PDF document'),
          content: const Text(
            'PDF preview is not available yet. The secure document '
            'viewer will be added in a later step.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final url = await _documentService.createDocumentViewUrl(
        organizationId: widget.organizationId,
        personId: widget.personId,
        credentialId: credential.id,
        documentId: document.id,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 800),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    document.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    tooltip: 'Close viewer',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 5,
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;

                        return const Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'The document could not be displayed. '
                            'It may have expired or access may be restricted.',
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (error) {
      debugPrint('Opening credential document failed: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The document could not be opened.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final assessment = widget.initialRequirementAssessment;
    final credential = assessment.matchingCredential;
    final expirationDate = credential?.expirationDate;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Compliance Record'),
        backgroundColor: Colors.white,
        foregroundColor: _navy,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.personName,
                    style: const TextStyle(color: _muted, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Compliance Record: ${assessment.displayName}',
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _InfoChip(label: assessment.statusLabel, color: _purple),
                      _InfoChip(
                        label: expirationDate == null
                            ? 'No expiration date'
                            : 'Expires ${_formatDate(expirationDate)}',
                        color: _muted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: const [
                      _SectionTab(label: 'Overview', selected: true),
                      _SectionTab(label: 'Evidence'),
                      _SectionTab(label: 'Review'),
                      _SectionTab(label: 'Timeline'),
                      _SectionTab(label: 'Related'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 900;

                      final overview = _SectionCard(
                        title: 'Requirement Context',
                        subtitle: 'Why this requirement applies',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DetailRow(
                              label: 'Person',
                              value: widget.personName,
                            ),
                            _DetailRow(
                              label: 'Functional Role',
                              value: assessment.roleName,
                            ),
                            _DetailRow(
                              label: 'Requirement',
                              value: assessment.displayName,
                            ),
                            _DetailRow(
                              label: 'Requirement Status',
                              value: assessment.statusLabel,
                            ),
                            _DetailRow(
                              label: 'Evidence Status',
                              value:
                                  credential?.status.label ?? 'Not submitted',
                            ),
                            _DetailRow(
                              label: 'Issuing Organization',
                              value:
                                  credential?.issuingOrganization ??
                                  'Not provided',
                            ),
                            _DetailRow(
                              label: 'Issue Date',
                              value: credential?.issueDate == null
                                  ? 'Not provided'
                                  : _formatDate(credential!.issueDate!),
                            ),
                            _DetailRow(
                              label: 'Expiration Date',
                              value: expirationDate == null
                                  ? 'Not provided'
                                  : _formatDate(expirationDate),
                            ),
                          ],
                        ),
                      );

                      final evidence = _SectionCard(
                        title: 'Evidence Documents',
                        subtitle:
                            'Supporting files associated with this credential',
                        child: _buildEvidenceContent(),
                      );

                      final reviewSummary = _buildReviewSummary();

                      if (!wide) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            overview,
                            const SizedBox(height: 16),
                            evidence,
                            const SizedBox(height: 16),
                            reviewSummary,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              children: [
                                overview,
                                const SizedBox(height: 16),
                                evidence,
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Expanded(
                            flex: 3,
                            child: _SectionCard(
                              title: 'Review Summary',
                              subtitle: 'Review workflow',
                              child: Text(
                                'Reviewer assignment, checklist, and '
                                'decisions will be added in the next '
                                'implementation steps.',
                                style: TextStyle(color: _muted),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEvidenceContent() {
    if (widget.initialRequirementAssessment.matchingCredential == null) {
      return const Text(
        'No credential has been submitted for this requirement yet.',
        style: TextStyle(color: _muted),
      );
    }

    if (_isLoadingDocuments) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_documentError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_documentError!, style: const TextStyle(color: _muted)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _loadDocuments,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      );
    }

    if (_documents.isEmpty) {
      return const Text(
        'No supporting documents have been uploaded for this credential.',
        style: TextStyle(color: _muted),
      );
    }

    return Column(
      children: [
        for (final document in _documents)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: _border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    document.contentType == 'application/pdf'
                        ? Icons.picture_as_pdf_outlined
                        : Icons.image_outlined,
                    color: _purple,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.fileName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _navy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_formatBytes(document.fileSize)}'
                          '${document.createdAt == null ? '' : ' · ${_formatDate(document.createdAt!)}'}',
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => _viewDocument(document),
                    child: const Text('View'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _saveChecklistItem({
    required Map<String, dynamic> item,
    required bool isComplete,
  }) async {
    final review = _review;
    if (review == null || _isSavingChecklist) return;

    final reviewId = review['id']?.toString();
    final itemId = item['id']?.toString();

    if (reviewId == null || itemId == null) return;

    setState(() => _isSavingChecklist = true);

    try {
      await _reviewService.updateChecklistItem(
        organizationId: widget.organizationId,
        reviewId: reviewId,
        itemId: itemId,
        isComplete: isComplete,
        result: isComplete ? 'pass' : null,
      );

      if (!mounted) return;

      setState(() {
        final index = _checklistItems.indexWhere(
          (existing) => existing['id']?.toString() == itemId,
        );

        if (index != -1) {
          _checklistItems[index] = {
            ..._checklistItems[index],
            'is_complete': isComplete,
            'result': isComplete ? 'pass' : null,
          };
        }
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save checklist item: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingChecklist = false);
      }
    }
  }

  Future<void> _submitReviewDecision({
    required String decision,
    required String comments,
    String? rejectionReason,
  }) async {
    final review = _review;
    if (review == null || _isSubmittingDecision) return;

    final reviewId = review['id']?.toString();
    if (reviewId == null) return;

    if (decision == 'reject' &&
        (rejectionReason == null || rejectionReason.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A rejection reason is required.')),
      );
      return;
    }

    setState(() => _isSubmittingDecision = true);

    try {
      await _reviewService.submitDecision(
        reviewId: reviewId,
        decision: decision,
        comments: comments,
        rejectionReason: rejectionReason,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review decision submitted.')),
      );

      await _loadReview();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not submit decision: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmittingDecision = false);
      }
    }
  }

  Future<void> _showDecisionDialog(String decision) async {
    final commentsController = TextEditingController();
    final rejectionController = TextEditingController();

    final title = switch (decision) {
      'approve' => 'Approve credential',
      'request_update' => 'Request an update',
      'reject' => 'Reject credential',
      _ => 'Submit decision',
    };

    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (decision == 'reject') ...[
                    const Text('Rejection reason (required)'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: rejectionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Explain why this credential is rejected',
                      ),
                      onChanged: (_) => setDialogState(() {}),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text('Comments (optional)'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: commentsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add notes for the audit trail',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed:
                    decision == 'reject' &&
                        rejectionController.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(dialogContext, true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      );

      if (confirmed != true || !mounted) return;

      await _submitReviewDecision(
        decision: decision,
        comments: commentsController.text,
        rejectionReason: decision == 'reject' ? rejectionController.text : null,
      );
    } finally {
      commentsController.dispose();
      rejectionController.dispose();
    }
  }

  Widget _buildReviewSummary() {
    if (_isLoadingReview) {
      return const _SectionCard(
        title: 'Review Summary',
        subtitle: 'Credential review workflow',
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_reviewError != null) {
      return _SectionCard(
        title: 'Review Summary',
        subtitle: 'Credential review workflow',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_reviewError!, style: const TextStyle(color: _muted)),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _loadReview,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final review = _review;

    if (review == null) {
      return _SectionCard(
        title: 'Review Summary',
        subtitle: 'Credential review workflow',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.fact_check_outlined, size: 30, color: _muted),
            const SizedBox(height: 12),
            const Text(
              'No review has been created yet.',
              style: TextStyle(color: _navy, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              _reviewLoadMessage ??
                  'A review record is needed before decisions can be recorded.',
              style: const TextStyle(color: _muted),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _loadReview,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    final status = (review['status'] ?? 'pending').toString().replaceAll(
      '_',
      ' ',
    );
    final priority = (review['priority'] ?? 'normal').toString().replaceAll(
      '_',
      ' ',
    );
    final completed = _checklistItems
        .where((item) => item['is_complete'] == true)
        .length;
    final total = _checklistItems.length;

    return _SectionCard(
      title: 'Review Summary',
      subtitle: 'Credential review workflow',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                label: status.toUpperCase(),
                color: status == 'approved'
                    ? Colors.green
                    : status == 'rejected'
                    ? Colors.red
                    : _purple,
              ),
              _InfoChip(
                label: 'Priority: ${priority.toUpperCase()}',
                color: priority == 'urgent' || priority == 'high'
                    ? Colors.deepOrange
                    : _muted,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Checklist Progress',
            style: TextStyle(color: _navy, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : completed / total,
                  minHeight: 7,
                  backgroundColor: _border,
                  color: _purple,
                ),
              ),
              const SizedBox(width: 12),
              Text('$completed / $total'),
            ],
          ),
          const SizedBox(height: 16),
          if (_checklistItems.isEmpty)
            const Text(
              'No checklist items are available.',
              style: TextStyle(color: _muted),
            )
          else
            ..._checklistItems.map((item) {
              final isComplete = item['is_complete'] == true;
              final isRequired = item['is_required'] == true;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isComplete,
                      onChanged: _isSavingChecklist
                          ? null
                          : (value) {
                              if (value != null) {
                                _saveChecklistItem(
                                  item: item,
                                  isComplete: value,
                                );
                              }
                            },
                      activeColor: _purple,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (item['label'] ?? 'Checklist item').toString(),
                              style: const TextStyle(color: _navy),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isRequired ? 'Required' : 'Optional',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          const Divider(height: 28),
          const Text(
            'Recent Decisions',
            style: TextStyle(color: _navy, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (_decisionHistory.isEmpty)
            const Text(
              'No decisions recorded.',
              style: TextStyle(color: _muted),
            )
          else
            ..._decisionHistory.take(3).map((decision) {
              final label = (decision['decision'] ?? 'Decision').toString();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  label.replaceAll('_', ' '),
                  style: const TextStyle(color: _navy),
                ),
              );
            }),
          const SizedBox(height: 8),
          Text(
            '${_auditHistory.length} audit events recorded',
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'Review Decision',
            style: TextStyle(color: _navy, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (_isSubmittingDecision)
            const Center(child: CircularProgressIndicator())
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => _showDecisionDialog('approve'),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Approve'),
                ),
                OutlinedButton(
                  onPressed: () => _showDecisionDialog('request_update'),
                  child: const Text('Request Update'),
                ),
                OutlinedButton(
                  onPressed: () => _showDecisionDialog('reject'),
                  child: const Text('Reject'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

const _purple = Color(0xFF5B4BC4);
const _navy = Color(0xFF1E293B);
const _muted = Color(0xFF64748B);
const _border = Color(0xFFE2E8F0);

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionTab extends StatelessWidget {
  const _SectionTab({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEDE9FE) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? _purple : _border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? _purple : _muted,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: _muted)),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(color: _muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: _navy,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
