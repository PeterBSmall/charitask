/// The kind of compliance requirement an organization defines.
///
/// This is intentionally separate from [CredentialCategory]: the requirement
/// describes what the organization expects, while the credential category is
/// only a matching hint for existing person credential records.
enum ComplianceRequirementType {
  certificationLicense('certification_license', 'Certification / License'),
  backgroundCheck('background_check', 'Background Check'),
  agreementAcknowledgement(
    'agreement_acknowledgement',
    'Agreement / Acknowledgement',
  ),
  training('training', 'Training'),
  medicalClearance('medical_clearance', 'Medical Clearance'),
  otherLegacy('other_legacy', 'Other (legacy)');

  const ComplianceRequirementType(this.value, this.label);

  final String value;
  final String label;

  static ComplianceRequirementType fromValue(Object? value) {
    for (final type in values) {
      if (type.value == value) return type;
    }
    return ComplianceRequirementType.otherLegacy;
  }

  /// Types that should be offered when creating a new requirement.
  static const List<ComplianceRequirementType> selectable = [
    certificationLicense,
    backgroundCheck,
    agreementAcknowledgement,
    training,
    medicalClearance,
  ];
}
