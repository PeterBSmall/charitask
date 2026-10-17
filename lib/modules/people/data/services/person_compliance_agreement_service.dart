import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/domain/models/person_compliance_agreement_acknowledgement.dart';

class PersonComplianceAgreementService {
  PersonComplianceAgreementService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
  static const String _table = 'person_compliance_agreement_acknowledgements';

  Future<List<PersonComplianceAgreementAcknowledgement>> getForOrganization({
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows)
        .map(PersonComplianceAgreementAcknowledgement.fromMap)
        .toList(growable: false);
  }

  Future<List<PersonComplianceAgreementAcknowledgement>> getForPerson({
    required String organizationId,
    required String personId,
  }) async {
    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows)
        .map(PersonComplianceAgreementAcknowledgement.fromMap)
        .toList(growable: false);
  }

  Future<List<PersonComplianceAgreementAcknowledgement>> getForRequirement({
    required String organizationId,
    required String complianceRequirementId,
  }) async {
    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .eq('compliance_requirement_id', complianceRequirementId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(rows)
        .map(PersonComplianceAgreementAcknowledgement.fromMap)
        .toList(growable: false);
  }

  /// Creates a pending acknowledgement for the requirement's current version.
  /// The database trigger snapshots that version on insert.
  Future<PersonComplianceAgreementAcknowledgement> createPending({
    required String organizationId,
    required String personId,
    required String complianceRequirementId,
  }) async {
    final row = await _supabase
        .from(_table)
        .insert({
          'organization_id': organizationId,
          'person_id': personId,
          'compliance_requirement_id': complianceRequirementId,
          'status': PersonComplianceAgreementStatus.pending.value,
        })
        .select()
        .single();
    return PersonComplianceAgreementAcknowledgement.fromMap(
      Map<String, dynamic>.from(row),
    );
  }

  /// Records acceptance with a timestamp and optional organization person ID
  /// for the accepting user. The accepted version remains stored on the row.
  Future<PersonComplianceAgreementAcknowledgement> accept({
    required String organizationId,
    required String acknowledgementId,
    String? acceptedByPersonId,
    DateTime? acceptedAt,
  }) async {
    final row = await _supabase
        .from(_table)
        .update({
          'status': PersonComplianceAgreementStatus.accepted.value,
          'accepted_at': (acceptedAt ?? DateTime.now()).toIso8601String(),
          'accepted_by_person_id': acceptedByPersonId,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('organization_id', organizationId)
        .eq('id', acknowledgementId)
        .select()
        .single();
    return PersonComplianceAgreementAcknowledgement.fromMap(
      Map<String, dynamic>.from(row),
    );
  }

  /// Updates the administrative status. Existing acceptance timestamps are not
  /// erased if an acknowledgement is later revoked, preserving the audit trail.
  Future<PersonComplianceAgreementAcknowledgement> updateStatus({
    required String organizationId,
    required String acknowledgementId,
    required PersonComplianceAgreementStatus status,
  }) async {
    if (status == PersonComplianceAgreementStatus.accepted) {
      throw ArgumentError(
        'Use accept() to record acceptance and its timestamp.',
      );
    }
    final row = await _supabase
        .from(_table)
        .update({
          'status': status.value,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('organization_id', organizationId)
        .eq('id', acknowledgementId)
        .select()
        .single();
    return PersonComplianceAgreementAcknowledgement.fromMap(
      Map<String, dynamic>.from(row),
    );
  }
}
