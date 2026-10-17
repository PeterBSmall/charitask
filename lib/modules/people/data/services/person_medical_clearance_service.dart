import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/domain/models/person_medical_clearance_record.dart';

class PersonMedicalClearanceService {
  PersonMedicalClearanceService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
  static const String _table = 'person_medical_clearance_records';

  Future<List<PersonMedicalClearanceRecord>> getForOrganization({
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(
      rows,
    ).map(PersonMedicalClearanceRecord.fromMap).toList(growable: false);
  }

  Future<List<PersonMedicalClearanceRecord>> getForPerson({
    required String organizationId,
    required String personId,
  }) async {
    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(
      rows,
    ).map(PersonMedicalClearanceRecord.fromMap).toList(growable: false);
  }

  Future<List<PersonMedicalClearanceRecord>> getForRequirement({
    required String organizationId,
    required String complianceRequirementId,
  }) async {
    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .eq('compliance_requirement_id', complianceRequirementId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(
      rows,
    ).map(PersonMedicalClearanceRecord.fromMap).toList(growable: false);
  }

  Future<PersonMedicalClearanceRecord> createRecord({
    required String organizationId,
    required String personId,
    required String complianceRequirementId,
    required PersonMedicalClearanceStatus status,
    DateTime? clearanceDate,
    DateTime? expirationDate,
    String? reviewedByPersonId,
  }) async {
    _validate(
      status: status,
      clearanceDate: clearanceDate,
      expirationDate: expirationDate,
    );
    final reviewedAt = status == PersonMedicalClearanceStatus.pending
        ? null
        : DateTime.now().toIso8601String();
    final row = await _supabase
        .from(_table)
        .insert({
          'organization_id': organizationId,
          'person_id': personId,
          'compliance_requirement_id': complianceRequirementId,
          'status': status.value,
          'clearance_date': _dateOnly(clearanceDate),
          'expiration_date': _dateOnly(expirationDate),
          'reviewed_at': reviewedAt,
          'reviewed_by_person_id': reviewedByPersonId,
        })
        .select()
        .single();
    return PersonMedicalClearanceRecord.fromMap(Map<String, dynamic>.from(row));
  }

  Future<PersonMedicalClearanceRecord> updateRecord({
    required String organizationId,
    required String recordId,
    required PersonMedicalClearanceStatus status,
    DateTime? clearanceDate,
    DateTime? expirationDate,
    String? reviewedByPersonId,
  }) async {
    _validate(
      status: status,
      clearanceDate: clearanceDate,
      expirationDate: expirationDate,
    );
    final reviewedAt = status == PersonMedicalClearanceStatus.pending
        ? null
        : DateTime.now().toIso8601String();
    final row = await _supabase
        .from(_table)
        .update({
          'status': status.value,
          'clearance_date': _dateOnly(clearanceDate),
          'expiration_date': _dateOnly(expirationDate),
          'reviewed_at': reviewedAt,
          'reviewed_by_person_id': reviewedByPersonId,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('organization_id', organizationId)
        .eq('id', recordId)
        .select()
        .single();
    return PersonMedicalClearanceRecord.fromMap(Map<String, dynamic>.from(row));
  }

  void _validate({
    required PersonMedicalClearanceStatus status,
    required DateTime? clearanceDate,
    required DateTime? expirationDate,
  }) {
    if (status == PersonMedicalClearanceStatus.cleared &&
        clearanceDate == null) {
      throw ArgumentError(
        'A clearance date is required when status is Cleared.',
      );
    }
    if (clearanceDate != null &&
        expirationDate != null &&
        expirationDate.isBefore(clearanceDate)) {
      throw ArgumentError(
        'Expiration date cannot be before the clearance date.',
      );
    }
  }
}

String? _dateOnly(DateTime? date) {
  if (date == null) return null;
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
