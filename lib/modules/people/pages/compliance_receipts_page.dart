import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';
import 'package:charitask/modules/locations/data/services/location_service.dart';
import 'package:charitask/modules/people/data/services/compliance_receipt_service.dart';
import 'package:charitask/modules/people/data/services/compliance_requirement_service.dart';
import 'package:charitask/modules/people/data/services/people_service.dart';
import 'package:charitask/modules/people/domain/models/compliance_requirement.dart';
import 'package:charitask/platform/authorization/authorization_service.dart';

class ComplianceReceiptsPage extends StatefulWidget {
  const ComplianceReceiptsPage({
    super.key,
    required this.organizationId,
    this.embedded = false,
  });

  final String organizationId;
  final bool embedded;

  @override
  State<ComplianceReceiptsPage> createState() => _ComplianceReceiptsPageState();
}

class _ComplianceReceiptsPageState extends State<ComplianceReceiptsPage> {
  late final AuthorizationService _authorization;
  late final ComplianceReceiptService _receiptService;
  late final ComplianceRequirementService _requirementService;
  late final PeopleService _peopleService;
  late final LocationService _locationService;

  List<Map<String, dynamic>> _receipts = [];
  List<Map<String, dynamic>> _people = [];
  List<ComplianceRequirement> _requirements = [];
  List<Location> _locations = [];

  bool _canView = false;
  bool _canReceive = false;
  bool _canReview = false;
  bool _loading = true;
  bool _working = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    final supabase = Supabase.instance.client;
    _authorization = AuthorizationService(supabase);
    _receiptService = ComplianceReceiptService(supabase: supabase);
    _requirementService = ComplianceRequirementService(supabase: supabase);
    _peopleService = PeopleService(supabase);
    _locationService = LocationService(supabase: supabase);

    _load();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final permissions = await Future.wait([
        _authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'compliance.receipts.view',
        ),
        _authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'compliance.receipts.receive',
        ),
        _authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'compliance.receipts.review',
        ),
      ]);

      final canView = permissions[0];
      final canReceive = permissions[1];
      final canReview = permissions[2];

      List<Map<String, dynamic>> receipts = [];
      List<Map<String, dynamic>> people = [];
      List<ComplianceRequirement> requirements = [];
      List<Location> locations = [];

      if (canView || canReview) {
        receipts = await _receiptService.getReceipts(
          organizationId: widget.organizationId,
        );
      }

      if (canReceive) {
        final results = await Future.wait([
          _peopleService.getPeople(organizationId: widget.organizationId),
          _requirementService.getRequirements(
            organizationId: widget.organizationId,
            activeOnly: true,
          ),
          _locationService.getLocations(organizationId: widget.organizationId),
        ]);

        people = results[0] as List<Map<String, dynamic>>;
        requirements = results[1] as List<ComplianceRequirement>;
        locations = results[2] as List<Location>;
      }

      if (!mounted) return;

      setState(() {
        _canView = canView;
        _canReceive = canReceive;
        _canReview = canReview;
        _receipts = receipts;
        _people = people;
        _requirements = requirements;
        _locations = locations;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Could not load receipt information. Please try again.';
      });

      debugPrint('ComplianceReceiptsPage load failed: $e');
    }
  }

  String _personName(Map<String, dynamic> person) {
    final preferred = (person['preferred_name'] as String?)?.trim();
    final first = (person['first_name'] as String?)?.trim() ?? '';
    final last = (person['last_name'] as String?)?.trim() ?? '';
    final given = preferred?.isNotEmpty == true ? preferred! : first;
    return '$given $last'.trim();
  }

  String _displayValue(dynamic value) {
    if (value == null) return '—';
    final text = value.toString().trim();
    return text.isEmpty ? '—' : text;
  }

  String _receiptStatusLabel(dynamic value) {
    switch (value?.toString()) {
      case 'pending_review':
        return 'Pending verification';
      case 'approved':
        return 'Verified';
      case 'rejected':
        return 'Rejected';
      default:
        return _displayValue(value).replaceAll('_', ' ');
    }
  }

  Future<void> _showReceiveDialog() async {
    if (!_canReceive ||
        _people.isEmpty ||
        _requirements.isEmpty ||
        _locations.isEmpty) {
      _showMessage(
        'Receiving paperwork requires an available person, active requirement, and receiving location.',
      );
      return;
    }

    String? personId;
    String? requirementId;
    String? locationId;
    final notesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Record received paperwork'),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: personId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Person'),
                        items: _people.map((person) {
                          final id = person['id'] as String;
                          return DropdownMenuItem<String>(
                            value: id,
                            child: Text(
                              _personName(person).isEmpty
                                  ? 'Unnamed person'
                                  : _personName(person),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() => personId = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: requirementId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Compliance requirement',
                        ),
                        items: _requirements.map((requirement) {
                          return DropdownMenuItem<String>(
                            value: requirement.id,
                            child: Text(
                              requirement.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() => requirementId = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: locationId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Receiving location',
                        ),
                        items: _locations.map((location) {
                          return DropdownMenuItem<String>(
                            value: location.id,
                            child: Text(
                              location.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setDialogState(() => locationId = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: notesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed:
                      personId != null &&
                          requirementId != null &&
                          locationId != null
                      ? () => Navigator.of(dialogContext).pop(true)
                      : null,
                  child: const Text('Record receipt'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) {
      notesController.dispose();
      return;
    }

    setState(() => _working = true);

    try {
      await _receiptService.submitReceipt(
        organizationId: widget.organizationId,
        personId: personId!,
        requirementId: requirementId!,
        receivingLocationId: locationId!,
        notes: notesController.text,
      );

      if (!mounted) return;

      _showMessage('Receipt recorded and submitted for review.');
      await _load();
    } catch (e) {
      debugPrint('Recording compliance receipt failed: $e');
      if (mounted) {
        _showMessage(
          'Could not record the receipt. Check your permissions and try again.',
        );
      }
    } finally {
      notesController.dispose();
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _reviewReceipt(
    Map<String, dynamic> receipt,
    String decision,
  ) async {
    if (!_canReview || receipt['status'] != 'pending_review') return;

    final notesController = TextEditingController();
    final approved = decision == 'approved';

    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(approved ? 'Verify receipt?' : 'Reject receipt?'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  approved
                      ? 'Confirm that this paperwork receipt is recorded correctly.'
                      : 'Provide a reason for rejecting this receipt.',
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  maxLength: 1000,
                  decoration: InputDecoration(
                    labelText: approved
                        ? 'Review notes (optional)'
                        : 'Rejection reason (required)',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!approved && notesController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter a reason before rejecting this receipt.',
                      ),
                    ),
                  );
                  return;
                }

                Navigator.of(dialogContext).pop(true);
              },
              child: Text(approved ? 'Verify' : 'Reject'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      setState(() => _working = true);

      await _receiptService.reviewReceipt(
        receiptId: receipt['id'].toString(),
        decision: decision,
        notes: notesController.text.trim(),
      );

      if (!mounted) return;

      _showMessage(approved ? 'Receipt verified.' : 'Receipt rejected.');
      await _load();
    } catch (e, stackTrace) {
      debugPrint('Reviewing compliance receipt failed: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (mounted) {
        _showMessage('Review failed: $e');
      }
    } finally {
      notesController.dispose();
      if (mounted) setState(() => _working = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _receiptCard(Map<String, dynamic> receipt) {
    final rawStatus = _displayValue(receipt['status']);
    final status = _receiptStatusLabel(receipt['status']);
    final pending = rawStatus == 'pending_review';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  _displayValue(
                    receipt['requirement_name'] ??
                        receipt['compliance_requirement_name'],
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Chip(label: Text(status)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Person: ${_displayValue(receipt['person_name'] ?? receipt['full_name'] ?? receipt['person_id'])}',
            ),
            Text(
              'Location: ${_displayValue(receipt['location_name'] ?? receipt['receiving_location_id'])}',
            ),
            Text('Received: ${_displayValue(receipt['received_at'])}'),
            if ((receipt['receipt_notes'] ?? receipt['notes']) != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Notes: ${receipt['receipt_notes'] ?? receipt['notes']}',
                ),
              ),
            if (_canReview && pending) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _working
                        ? null
                        : () => _reviewReceipt(receipt, 'rejected'),
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                  ),
                  FilledButton.icon(
                    onPressed: _working
                        ? null
                        : () => _reviewReceipt(receipt, 'approved'),
                    icon: const Icon(Icons.check),
                    label: const Text('Verify'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _load, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    if (!_canView && !_canReceive && !_canReview) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'You do not have permission to access compliance receipts.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_working) const LinearProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Record and review received compliance paperwork.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (_canReceive) ...[
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _working ? null : _showReceiveDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Record receipt'),
                ),
              ],
            ],
          ),
        ),
        if (!_canView && !_canReview)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'You can record receipts, but do not have permission to view the receipt list.',
              textAlign: TextAlign.center,
            ),
          )
        else if (_receipts.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No compliance receipts found.'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: _receipts.length,
            itemBuilder: (context, index) => _receiptCard(_receipts[index]),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return _buildReceiptContent();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compliance Receipts'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading || _working ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(child: _buildReceiptContent()),
    );
  }
}
