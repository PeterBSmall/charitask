import 'package:charitask/modules/people/domain/models/compliance_rule_settings.dart';
import 'package:charitask/modules/people/domain/models/compliance_requirement_type.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';

class ComplianceRequirementTemplate {
  const ComplianceRequirementTemplate({
    required this.id,
    required this.slug,
    required this.name,
    required this.requirementType,
    required this.defaultRules,
    required this.isSystem,
    required this.isActive,
    this.organizationId,
    this.credentialCategory,
    this.description,
  });

  final String id;
  final String? organizationId;
  final String slug;
  final String name;
  final ComplianceRequirementType requirementType;
  final CredentialCategory? credentialCategory;
  final String? description;
  final ComplianceRuleSettings defaultRules;
  final bool isSystem;
  final bool isActive;

  bool get isOrganizationTemplate => organizationId != null && !isSystem;

  factory ComplianceRequirementTemplate.fromMap(Map<String, dynamic> map) {
    final rawCategory = map['credential_category'];
    return ComplianceRequirementTemplate(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String?,
      slug: map['slug'] as String,
      name: map['name'] as String,
      requirementType: ComplianceRequirementType.fromValue(
        map['requirement_type'],
      ),
      credentialCategory: rawCategory == null
          ? null
          : CredentialCategory.fromValue(rawCategory),
      description: map['description'] as String?,
      defaultRules: ComplianceRuleSettings.fromMap(map['default_rules']),
      isSystem: map['is_system'] == true,
      isActive: map['is_active'] != false,
    );
  }
}
