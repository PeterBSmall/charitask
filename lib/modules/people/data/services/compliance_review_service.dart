import 'package:supabase_flutter/supabase_flutter.dart';

/// Data access for the compliance credential review workflow.
///
/// Row-level security remains responsible for restricting review visibility.
/// Decisions are submitted through the secured database RPC.
class ComplianceReviewService {
  final SupabaseClient _supabase;

  ComplianceReviewService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  /// Loads review records visible to the current user for an organization.
  ///
  /// The query deliberately avoids joining credential or person details until
  /// their relationship and background-check access rules are confirmed.
  Future<List<Map<String, dynamic>>> getReviews({
    required String organizationId,
    String? status,
  }) async {
    var query = _supabase
        .from('person_credential_reviews')
        .select(
          'id, organization_id, person_id, credential_id, status, priority, '
          'assigned_reviewer_person_id, assigned_at, submitted_at, '
          'decided_at, due_at, created_by_person_id, created_at, updated_at',
        )
        .eq('organization_id', organizationId);

    if (status != null && status.isNotEmpty && status != 'all') {
      query = query.eq('status', status);
    }

    final rows = await query
        .order('priority')
        .order('due_at', nullsFirst: false)
        .order('submitted_at', ascending: true, nullsFirst: false);

    return List<Map<String, dynamic>>.from(rows);
  }

  /// Loads checklist items for one review.
  Future<List<Map<String, dynamic>>> getChecklistItems({
    required String organizationId,
    required String reviewId,
  }) async {
    final rows = await _supabase
        .from('person_credential_review_checklist_items')
        .select(
          'id, organization_id, review_id, item_key, label, item_type, '
          'is_required, is_complete, result, completed_by_person_id, '
          'completed_at, sort_order, created_at, updated_at',
        )
        .eq('organization_id', organizationId)
        .eq('review_id', reviewId)
        .order('sort_order')
        .order('label');

    return List<Map<String, dynamic>>.from(rows);
  }

  /// Submits a review decision through the authorized database function.
  ///
  /// Supported decisions: approve, request_update, reject.
  Future<String> submitDecision({
    required String reviewId,
    required String decision,
    String? comments,
    String? rejectionReason,
  }) async {
    const supportedDecisions = {'approve', 'request_update', 'reject'};

    if (!supportedDecisions.contains(decision)) {
      throw ArgumentError.value(decision, 'decision', 'Unsupported decision');
    }

    if (decision == 'reject' &&
        (rejectionReason == null || rejectionReason.trim().isEmpty)) {
      throw ArgumentError('A rejection reason is required.');
    }

    final result = await _supabase.rpc(
      'submit_person_credential_review_decision',
      params: {
        'p_review_id': reviewId,
        'p_decision': decision,
        'p_comments': _cleanOptional(comments),
        'p_rejection_reason': _cleanOptional(rejectionReason),
      },
    );

    if (result == null) {
      throw StateError('The review decision did not return a review ID.');
    }

    return result.toString();
  }

  /// Saves a checklist result and completion metadata.
  Future<void> updateChecklistItem({
    required String organizationId,
    required String reviewId,
    required String itemId,
    required bool isComplete,
    String? result,
  }) async {
    const supportedResults = {'pass', 'fail', 'not_applicable'};

    if (result != null && !supportedResults.contains(result)) {
      throw ArgumentError.value(result, 'result', 'Unsupported result');
    }

    final userId = _supabase.auth.currentUser?.id;
    final update = <String, dynamic>{
      'is_complete': isComplete,
      'result': result,
      'completed_at': isComplete
          ? DateTime.now().toUtc().toIso8601String()
          : null,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    // The database stores the person ID, not the Supabase auth user ID.
    // Leave completed_by_person_id unchanged until the app's identity mapping
    // is available to this service.
    if (userId != null) {
      // Authentication is confirmed; RLS still authorizes the write.
    }

    await _supabase
        .from('person_credential_review_checklist_items')
        .update(update)
        .eq('organization_id', organizationId)
        .eq('review_id', reviewId)
        .eq('id', itemId);
  }

  /// Loads the decision history for a review.
  Future<List<Map<String, dynamic>>> getDecisionHistory({
    required String organizationId,
    required String reviewId,
  }) async {
    final rows = await _supabase
        .from('person_credential_review_decisions')
        .select(
          'id, decision, comments, rejection_reason, '
          'decided_by_person_id, created_at',
        )
        .eq('organization_id', organizationId)
        .eq('review_id', reviewId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(rows);
  }

  /// Loads the audit timeline for a review.
  Future<List<Map<String, dynamic>>> getAuditHistory({
    required String organizationId,
    required String reviewId,
  }) async {
    final rows = await _supabase
        .from('person_credential_review_audit_events')
        .select()
        .eq('organization_id', organizationId)
        .eq('review_id', reviewId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(rows);
  }

  String? _cleanOptional(String? value) {
    final cleaned = value?.trim();
    return cleaned == null || cleaned.isEmpty ? null : cleaned;
  }
}
