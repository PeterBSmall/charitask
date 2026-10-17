enum PersonComplianceAgreementStatus {
  pending('pending', 'Pending'),
  accepted('accepted', 'Accepted'),
  declined('declined', 'Declined'),
  revoked('revoked', 'Revoked');

  const PersonComplianceAgreementStatus(this.value, this.label);

  final String value;
  final String label;

  static PersonComplianceAgreementStatus fromValue(Object? value) {
    for (final status in values) {
      if (status.value == value) return status;
    }
    return PersonComplianceAgreementStatus.pending;
  }
}

/// A person's response to a specific version of an agreement requirement.
///
/// The version is a snapshot. If the organization later changes the requirement
/// version, an acknowledgement for the new version should be created rather
/// than overwriting this record's version history.
class PersonComplianceAgreementAcknowledgement {
  const PersonComplianceAgreementAcknowledgement({
    required this.id,
    required this.organizationId,
    required this.personId,
    required this.complianceRequirementId,
    required this.agreementVersion,
    required this.status,
    this.acceptedAt,
    this.acceptedByPersonId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String organizationId;
  final String personId;
  final String complianceRequirementId;
  final String agreementVersion;
  final PersonComplianceAgreementStatus status;
  final DateTime? acceptedAt;
  final String? acceptedByPersonId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isAccepted => status == PersonComplianceAgreementStatus.accepted;

  factory PersonComplianceAgreementAcknowledgement.fromMap(
    Map<String, dynamic> map,
  ) {
    return PersonComplianceAgreementAcknowledgement(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      personId: map['person_id'] as String,
      complianceRequirementId: map['compliance_requirement_id'] as String,
      agreementVersion: map['agreement_version']?.toString() ?? '1',
      status: PersonComplianceAgreementStatus.fromValue(map['status']),
      acceptedAt: _parseDate(map['accepted_at']),
      acceptedByPersonId: map['accepted_by_person_id'] as String?,
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
