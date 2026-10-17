import 'package:charitask/modules/people/domain/models/compliance_requirement_type.dart';
import 'package:charitask/modules/people/domain/models/compliance_rule_settings.dart';
import 'package:charitask/modules/people/domain/models/functional_role_compliance_requirement.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';

class ComplianceRequirement {
  const ComplianceRequirement({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.requirementType,
    required this.rules,
    required this.isActive,
    this.credentialCategory,
    this.description,
    this.sourceTemplateId,
    this.createdAt,
    this.updatedAt,
    this.roleAssignments = const [],
    this.personTypes = const [],
    this.groupIds = const [],
  });

  final String id;
  final String organizationId;
  final String name;
  final ComplianceRequirementType requirementType;
  final CredentialCategory? credentialCategory;
  final String? description;
  final ComplianceRuleSettings rules;
  final String? sourceTemplateId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<FunctionalRoleComplianceRequirement> roleAssignments;
  final List<String> personTypes;
  final List<String> groupIds;

  List<String> get functionalRoleIds => roleAssignments
      .map((assignment) => assignment.functionalRoleId)
      .toSet()
      .toList(growable: false);

  factory ComplianceRequirement.fromMap(Map<String, dynamic> map) {
    final rawCategory = map['credential_category'];
    final rawRoleIds = map['role_ids'];
    final nestedAssignments = map['functional_role_compliance_requirements'];
    final rawPersonTypes = map['person_types'];
    final nestedPersonTypes = map['compliance_requirement_person_types'];
    final rawGroupIds = map['group_ids'];
    final nestedGroups = map['compliance_requirement_groups'];
    final assignments = <FunctionalRoleComplianceRequirement>[];
    final personTypes = <String>{};
    final groupIds = <String>{};

    if (rawPersonTypes is List) {
      personTypes.addAll(rawPersonTypes.whereType<String>());
    } else if (nestedPersonTypes is List) {
      for (final raw in nestedPersonTypes.whereType<Map>()) {
        final personType = raw['person_type'];
        if (personType is String && personType.trim().isNotEmpty) {
          personTypes.add(personType.trim());
        }
      }
    }

    if (rawGroupIds is List) {
      groupIds.addAll(rawGroupIds.whereType<String>());
    } else if (nestedGroups is List) {
      for (final raw in nestedGroups.whereType<Map>()) {
        final groupId = raw['group_id'];
        if (groupId is String && groupId.isNotEmpty) {
          groupIds.add(groupId);
        }
      }
    }

    if (rawRoleIds is List) {
      for (final roleId in rawRoleIds.whereType<String>()) {
        assignments.add(
          FunctionalRoleComplianceRequirement(
            organizationId: map['organization_id'] as String,
            functionalRoleId: roleId,
            complianceRequirementId: map['id'] as String,
            isRequired: true,
          ),
        );
      }
    } else if (nestedAssignments is List) {
      for (final raw in nestedAssignments.whereType<Map>()) {
        final nested = Map<String, dynamic>.from(raw);
        final roleId = nested['functional_role_id'];
        if (roleId is! String) continue;
        assignments.add(
          FunctionalRoleComplianceRequirement(
            organizationId: map['organization_id'] as String,
            functionalRoleId: roleId,
            complianceRequirementId: map['id'] as String,
            isRequired: nested['is_required'] != false,
            createdAt: _parseDate(nested['created_at']),
          ),
        );
      }
    }

    return ComplianceRequirement(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      name: map['name'] as String,
      requirementType: ComplianceRequirementType.fromValue(
        map['requirement_type'],
      ),
      credentialCategory: rawCategory == null
          ? null
          : CredentialCategory.fromValue(rawCategory),
      description: map['description'] as String?,
      rules: ComplianceRuleSettings.fromMap(map['rules']),
      sourceTemplateId: map['source_template_id'] as String?,
      isActive: map['is_active'] != false,
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
      roleAssignments: assignments,
      personTypes: personTypes.toList()..sort(),
      groupIds: groupIds.toList(),
    );
  }

  Map<String, dynamic> toRpcArguments({
    required List<String> functionalRoleIds,
  }) => {
    'p_organization_id': organizationId,
    'p_name': name.trim(),
    'p_requirement_type': requirementType.value,
    'p_credential_category': credentialCategory?.value,
    'p_description': _nullableText(description),
    'p_rules': rules.toMap(),
    'p_source_template_id': sourceTemplateId,
    'p_functional_role_ids': functionalRoleIds.toSet().toList(),
  };
}

String? _nullableText(String? value) {
  final clean = value?.trim();
  return clean == null || clean.isEmpty ? null : clean;
}

DateTime? _parseDate(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}
