class FunctionalRoleComplianceRequirement {
  const FunctionalRoleComplianceRequirement({
    required this.organizationId,
    required this.functionalRoleId,
    required this.complianceRequirementId,
    required this.isRequired,
    this.createdAt,
  });

  final String organizationId;
  final String functionalRoleId;
  final String complianceRequirementId;
  final bool isRequired;
  final DateTime? createdAt;

  factory FunctionalRoleComplianceRequirement.fromMap(
    Map<String, dynamic> map,
  ) {
    return FunctionalRoleComplianceRequirement(
      organizationId: map['organization_id'] as String,
      functionalRoleId: map['functional_role_id'] as String,
      complianceRequirementId: map['compliance_requirement_id'] as String,
      isRequired: map['is_required'] != false,
      createdAt: _parseDate(map['created_at']),
    );
  }
}

DateTime? _parseDate(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
