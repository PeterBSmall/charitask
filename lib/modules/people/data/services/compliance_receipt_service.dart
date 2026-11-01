import 'package:supabase_flutter/supabase_flutter.dart';

/// Data access for compliance paperwork receipts and independent review.
///
/// Recording a receipt does not mark a compliance requirement as satisfied.
class ComplianceReceiptService {
  ComplianceReceiptService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  static const _table = 'person_compliance_receipt_submissions';

  /// Loads receipt submissions visible under the database's RLS policies.

  /// Loads receipt submissions and resolves display names from their tables.
  Future<List<Map<String, dynamic>>> getReceipts({
    required String organizationId,
    String? status,
  }) async {
    var query = _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId);

    if (status != null && status.isNotEmpty) {
      query = query.eq('status', status);
    }

    final rows = await query.order('received_at', ascending: false);
    final receipts = List<Map<String, dynamic>>.from(rows);

    if (receipts.isEmpty) return receipts;

    // Load the related records separately to avoid ambiguous joins.
    final personIds = receipts
        .map((r) => r['person_id'] as String)
        .toSet()
        .toList();

    final requirementIds = receipts
        .map((r) => r['compliance_requirement_id'] as String)
        .toSet()
        .toList();

    final locationIds = receipts
        .map((r) => r['receiving_location_id'] as String)
        .toSet()
        .toList();

    final peopleRows = await _supabase
        .from('persons')
        .select('id, first_name, last_name, preferred_name')
        .eq('organization_id', organizationId)
        .inFilter('id', personIds);

    final requirementRows = await _supabase
        .from('compliance_requirements')
        .select('id, name')
        .eq('organization_id', organizationId)
        .inFilter('id', requirementIds);

    final locationRows = await _supabase
        .from('locations')
        .select('id, name')
        .eq('organization_id', organizationId)
        .inFilter('id', locationIds);

    final peopleById = {for (final row in peopleRows) row['id'] as String: row};

    final requirementsById = {
      for (final row in requirementRows) row['id'] as String: row,
    };

    final locationsById = {
      for (final row in locationRows) row['id'] as String: row,
    };

    return receipts.map((receipt) {
      final person = peopleById[receipt['person_id']];
      final requirement =
          requirementsById[receipt['compliance_requirement_id']];
      final location = locationsById[receipt['receiving_location_id']];

      final firstName =
          person?['preferred_name'] as String? ??
          person?['first_name'] as String? ??
          '';
      final lastName = person?['last_name'] as String? ?? '';

      return {
        ...receipt,
        'person_name': '$firstName $lastName'.trim(),
        'requirement_name':
            requirement?['name'] as String? ?? 'Unknown requirement',
        'location_name': location?['name'] as String? ?? 'Unknown location',
      };
    }).toList();
  }

  /// Records receipt of paperwork. The database sets the receipt timestamp
  /// and identifies the signed-in receiving person.
  Future<String> submitReceipt({
    required String organizationId,
    required String personId,
    required String requirementId,
    required String receivingLocationId,
    String? notes,
  }) async {
    final result = await _supabase.rpc(
      'submit_person_compliance_receipt',
      params: {
        'p_organization_id': organizationId,
        'p_person_id': personId,
        'p_compliance_requirement_id': requirementId,
        'p_receiving_location_id': receivingLocationId,
        'p_receipt_notes': _nullableText(notes),
      },
    );

    return result.toString();
  }

  /// Approves or rejects a pending receipt. The database enforces that the
  /// reviewer differs from the person who received the paperwork.
  Future<void> reviewReceipt({
    required String receiptId,
    required String decision,
    String? notes,
  }) async {
    if (decision != 'approved' && decision != 'rejected') {
      throw ArgumentError.value(
        decision,
        'decision',
        'Must be approved or rejected.',
      );
    }

    await _supabase.rpc(
      'review_person_compliance_receipt',
      params: {
        'p_receipt_id': receiptId,
        'p_decision': decision,
        'p_review_notes': _nullableText(notes),
      },
    );
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
