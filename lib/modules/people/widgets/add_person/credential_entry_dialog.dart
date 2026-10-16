import 'package:flutter/material.dart';

import 'package:charitask/modules/people/domain/models/person_credential.dart';
import 'package:charitask/modules/people/domain/models/person_credential_document.dart';
import 'package:charitask/modules/people/widgets/add_person/credential_document_picker.dart';

class CredentialEntryDialog extends StatefulWidget {
  final PersonCredentialDraft? initialCredential;
  final List<CredentialCategory>? allowedCategories;
  final bool lockCategory;
  final String? initialCredentialName;
  final bool lockCredentialName;

  const CredentialEntryDialog({
    super.key,
    this.initialCredential,
    this.allowedCategories,
    this.lockCategory = false,
    this.initialCredentialName,
    this.lockCredentialName = false,
  });

  @override
  State<CredentialEntryDialog> createState() => _CredentialEntryDialogState();
}

class _CredentialEntryDialogState extends State<CredentialEntryDialog> {
  static const _purple = Color(0xFF5B4BC4);
  static const _cyan = Color(0xFF0891B2);
  static const _border = Color(0xFFE1E5EC);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _issuerController;

  late CredentialCategory _category;
  late CredentialStatus _status;

  DateTime? _issueDate;
  DateTime? _expirationDate;

  List<CredentialDocumentDraft> _documents = [];

  bool get _isEditing => widget.initialCredential != null;

  List<CredentialCategory> get _availableCategories =>
      widget.allowedCategories ?? CredentialCategory.values;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialCredential;

    _nameController = TextEditingController(
      text: widget.initialCredentialName ?? initial?.credentialName ?? '',
    );

    _issuerController = TextEditingController(
      text: initial?.issuingOrganization ?? '',
    );

    _category =
        initial?.category ??
        (_availableCategories.contains(CredentialCategory.certification)
            ? CredentialCategory.certification
            : _availableCategories.first);

    _status = initial?.status ?? CredentialStatus.pending;
    _issueDate = initial?.issueDate;
    _expirationDate = initial?.expirationDate;

    _documents = List<CredentialDocumentDraft>.from(
      initial?.documents ?? const [],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(
    String label, {
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _cyan, width: 1.5),
      ),
    );
  }

  Future<void> _pickIssueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _issueDate ?? _expirationDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked == null || !mounted) return;

    setState(() {
      _issueDate = picked;

      if (_expirationDate != null && _expirationDate!.isBefore(picked)) {
        _expirationDate = null;
      }
    });
  }

  Future<void> _pickExpirationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? _issueDate ?? DateTime.now(),
      firstDate: _issueDate ?? DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked == null || !mounted) return;

    setState(() {
      _expirationDate = picked;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';

    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _dateField({
    required String label,
    required DateTime? date,
    required VoidCallback onPick,
    required VoidCallback onClear,
  }) {
    return InputDecorator(
      decoration: _decoration(label),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _formatDate(date),
              style: TextStyle(
                fontSize: 14,
                color: date == null
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF1E293B),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Choose date',
            onPressed: onPick,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          if (date != null)
            IconButton(
              tooltip: 'Clear date',
              onPressed: onClear,
              icon: const Icon(Icons.close),
            ),
        ],
      ),
    );
  }

  Future<void> _changeCategory(CredentialCategory category) async {
    if (widget.lockCategory ||
        !_availableCategories.contains(category) ||
        category == _category) {
      return;
    }

    if (category.isBackgroundCheck && _documents.isNotEmpty) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Remove Supporting Documents?'),
          content: const Text(
            'Supporting documents cannot be attached to background '
            'checks in this workflow. Switching categories will '
            'remove the selected files from this draft.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Switch Category'),
            ),
          ],
        ),
      );

      if (!mounted || confirmed != true) return;

      setState(() {
        _documents = [];
      });
    }

    if (!mounted) return;

    setState(() {
      _category = category;

      final allowedStatuses = CredentialStatus.forCategory(category);

      if (!allowedStatuses.contains(_status)) {
        _status = CredentialStatus.pending;
      }
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    if (_issueDate != null &&
        _expirationDate != null &&
        _expirationDate!.isBefore(_issueDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expiration date must be on or after the issue date.'),
        ),
      );
      return;
    }

    Navigator.of(context).pop(
      PersonCredentialDraft(
        category: _category,
        credentialName: _nameController.text.trim(),
        issuingOrganization: _issuerController.text.trim().isEmpty
            ? null
            : _issuerController.text.trim(),
        issueDate: _issueDate,
        expirationDate: _expirationDate,
        status: _status,
        documents: _documents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.workspace_premium_outlined, color: _cyan),
          const SizedBox(width: 12),
          Expanded(
            child: Text(_isEditing ? 'Edit Credential' : 'Add Credential'),
          ),
        ],
      ),
      content: SizedBox(
        width: screenSize.width < 720 ? screenSize.width * 0.82 : 500,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: screenSize.height * 0.68),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Record a certification, license, training, '
                    'or compliance item.',
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    readOnly: widget.lockCredentialName,
                    textCapitalization: TextCapitalization.words,
                    decoration: _decoration(
                      'Credential Name *',
                      hint: 'e.g. Safety Orientation',
                      suffixIcon: widget.lockCredentialName
                          ? const Icon(Icons.lock_outline)
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a credential name.';
                      }

                      return null;
                    },
                  ),
                  if (widget.lockCredentialName) ...[
                    const SizedBox(height: 5),
                    const Text(
                      'This name comes from the configured role requirement.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CredentialCategory>(
                    initialValue: _category,
                    isExpanded: true,
                    decoration: _decoration('Category'),
                    items: _availableCategories
                        .map(
                          (category) => DropdownMenuItem<CredentialCategory>(
                            value: category,
                            child: Text(category.label),
                          ),
                        )
                        .toList(),
                    onChanged: widget.lockCategory
                        ? null
                        : (value) {
                            if (value != null) {
                              _changeCategory(value);
                            }
                          },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _issuerController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _decoration(
                      'Issuing Organization',
                      hint: 'e.g. American Red Cross',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _dateField(
                    label: 'Issue Date',
                    date: _issueDate,
                    onPick: _pickIssueDate,
                    onClear: () {
                      setState(() => _issueDate = null);
                    },
                  ),
                  const SizedBox(height: 16),
                  _dateField(
                    label: 'Expiration Date',
                    date: _expirationDate,
                    onPick: _pickExpirationDate,
                    onClear: () {
                      setState(() => _expirationDate = null);
                    },
                  ),
                  // Supporting documents are available for ordinary
                  // credentials, but not for background checks.
                  if (!_category.isBackgroundCheck) ...[
                    const SizedBox(height: 22),
                    CredentialDocumentPicker(
                      documents: _documents,
                      onChanged: (documents) {
                        setState(() {
                          _documents = documents;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CredentialStatus>(
                    initialValue: _status,
                    isExpanded: true,
                    decoration: _decoration(
                      _category.isBackgroundCheck
                          ? 'Background Check Status'
                          : 'Verification Status',
                    ),
                    items: CredentialStatus.forCategory(_category)
                        .map(
                          (status) => DropdownMenuItem<CredentialStatus>(
                            value: status,
                            child: Text(status.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() => _status = value);
                    },
                  ),
                  if (_category.isBackgroundCheck) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFED7AA)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lock_outline, color: Color(0xFF9A3412)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Only record the status and relevant '
                              'dates here. Do not enter sensitive '
                              'report details.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: Color(0xFF9A3412),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: _purple,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.check, size: 18),
          label: Text(_isEditing ? 'Save Changes' : 'Add Credential'),
        ),
      ],
    );
  }
}
