enum PersonMedicalClearanceStatus {
  pending('pending', 'Pending'),
  cleared('cleared', 'Cleared'),
  reviewRequired('review_required', 'Review Required'),
  notCleared('not_cleared', 'Not Cleared');

  const PersonMedicalClearanceStatus(this.value, this.label);

  final String value;
  final String label;

  static PersonMedicalClearanceStatus fromValue(Object? value) {
    for (final status in values) {
      if (status.value == value) return status;
    }
    return PersonMedicalClearanceStatus.pending;
  }
}

/// Administrative medical-clearance result only.
/// Do not add diagnoses, treatment details, or clinical notes here.
class PersonMedicalClearanceRecord {
  const PersonMedicalClearanceRecord({
    required this.id,
    required this.organizationId,
    required this.personId,
    required this.complianceRequirementId,
    required this.status,
    this.clearanceDate,
    this.expirationDate,
    this.reviewedAt,
    this.reviewedByPersonId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String organizationId;
  final String personId;
  final String complianceRequirementId;
  final PersonMedicalClearanceStatus status;
  final DateTime? clearanceDate;
  final DateTime? expirationDate;
  final DateTime? reviewedAt;
  final String? reviewedByPersonId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isExpired {
    final expiration = expirationDate;
    if (expiration == null) return false;
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedExpiration = DateTime(
      expiration.year,
      expiration.month,
      expiration.day,
    );
    return normalizedExpiration.isBefore(normalizedToday);
  }

  factory PersonMedicalClearanceRecord.fromMap(Map<String, dynamic> map) {
    return PersonMedicalClearanceRecord(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      personId: map['person_id'] as String,
      complianceRequirementId: map['compliance_requirement_id'] as String,
      status: PersonMedicalClearanceStatus.fromValue(map['status']),
      clearanceDate: _parseDate(map['clearance_date']),
      expirationDate: _parseDate(map['expiration_date']),
      reviewedAt: _parseDate(map['reviewed_at']),
      reviewedByPersonId: map['reviewed_by_person_id'] as String?,
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }
}

DateTime? _parseDate(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
