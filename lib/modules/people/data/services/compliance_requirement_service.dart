import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/domain/models/compliance_requirement.dart';
import 'package:charitask/modules/people/domain/models/compliance_requirement_template.dart';
import 'package:charitask/modules/people/domain/models/compliance_requirement_type.dart';
import 'package:charitask/modules/people/domain/models/compliance_rule_settings.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';

/// Data access for reusable organization Compliance Requirements and templates.
///
/// Multi-table writes go through database RPCs so requirement definitions and
/// all target assignments (person types, functional roles, and groups) succeed
/// or fail together in one transaction.
class ComplianceRequirementService {
  ComplianceRequirementService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  static const _templatesTable = 'compliance_requirement_templates';
  static const _requirementsTable = 'compliance_requirements';

  /// Loads system templates and templates belonging to [organizationId].
  /// RLS restricts the server response; this method also scopes the visible
  /// results to the requested organization and the global template library.
  Future<List<ComplianceRequirementTemplate>> getTemplates({
    required String organizationId,
    bool activeOnly = true,
  }) async {
    final rows = await _supabase.from(_templatesTable).select().order('name');

    return List<Map<String, dynamic>>.from(rows)
        .map(ComplianceRequirementTemplate.fromMap)
        .where(
          (template) =>
              (template.organizationId == null ||
                  template.organizationId == organizationId) &&
              (!activeOnly || template.isActive),
        )
        .toList(growable: false);
  }

  /// Loads reusable requirements with their linked functional-role IDs.
  Future<List<ComplianceRequirement>> getRequirements({
    required String organizationId,
    bool activeOnly = true,
  }) async {
    final rows = await _supabase
        .from(_requirementsTable)
        .select(
          '*, '
          'functional_role_compliance_requirements(functional_role_id, is_required, created_at), '
          'compliance_requirement_person_types(person_type), '
          'compliance_requirement_groups(group_id)',
        )
        .eq('organization_id', organizationId)
        .order('name');

    return List<Map<String, dynamic>>.from(rows)
        .map(ComplianceRequirement.fromMap)
        .where((requirement) => !activeOnly || requirement.isActive)
        .toList(growable: false);
  }

  /// Loads active groups available as optional compliance targets.
  /// The caller should check `groups.view` before invoking this method.
  Future<List<Map<String, dynamic>>> getGroups({
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from('groups')
        .select('id, name, group_type')
        .eq('organization_id', organizationId)
        .eq('status', 'active')
        .isFilter('archived_at', null)
        .order('name');

    return List<Map<String, dynamic>>.from(rows);
  }

  /// Creates a definition and saves all selected targeting methods atomically.
  Future<ComplianceRequirement> createRequirement({
    required String organizationId,
    required String name,
    required ComplianceRequirementType requirementType,
    required CredentialCategory? credentialCategory,
    String? description,
    required ComplianceRuleSettings rules,
    String? sourceTemplateId,
    required List<String> functionalRoleIds,
    required List<String> personTypes,
    required List<String> groupIds,
  }) async {
    _validateTargets(
      functionalRoleIds: functionalRoleIds,
      personTypes: personTypes,
      groupIds: groupIds,
    );

    final result = await _supabase.rpc(
      'create_compliance_requirement_with_targets',
      params: {
        'p_organization_id': organizationId,
        'p_name': name.trim(),
        'p_requirement_type': requirementType.value,
        'p_credential_category': credentialCategory?.value,
        'p_description': _nullableText(description),
        'p_rules': rules.toMap(),
        'p_source_template_id': sourceTemplateId,
        'p_functional_role_ids': functionalRoleIds.toSet().toList(),
        'p_person_types': personTypes
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toSet()
            .toList(),
        'p_group_ids': groupIds.toSet().toList(),
      },
    );

    return ComplianceRequirement.fromMap(_asMap(result));
  }

  /// Updates a definition and replaces all targeting methods atomically.
  Future<ComplianceRequirement> updateRequirement({
    required String organizationId,
    required String requirementId,
    required String name,
    required ComplianceRequirementType requirementType,
    required CredentialCategory? credentialCategory,
    String? description,
    required ComplianceRuleSettings rules,
    String? sourceTemplateId,
    required List<String> functionalRoleIds,
    required List<String> personTypes,
    required List<String> groupIds,
  }) async {
    _validateTargets(
      functionalRoleIds: functionalRoleIds,
      personTypes: personTypes,
      groupIds: groupIds,
    );

    final result = await _supabase.rpc(
      'update_compliance_requirement_with_targets',
      params: {
        'p_organization_id': organizationId,
        'p_compliance_requirement_id': requirementId,
        'p_name': name.trim(),
        'p_requirement_type': requirementType.value,
        'p_credential_category': credentialCategory?.value,
        'p_description': _nullableText(description),
        'p_rules': rules.toMap(),
        'p_source_template_id': sourceTemplateId,
        'p_functional_role_ids': functionalRoleIds.toSet().toList(),
        'p_person_types': personTypes
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toSet()
            .toList(),
        'p_group_ids': groupIds.toSet().toList(),
      },
    );

    return ComplianceRequirement.fromMap(_asMap(result));
  }

  /// Archives a requirement without deleting its history or person records.
  Future<void> archiveRequirement({
    required String organizationId,
    required String requirementId,
  }) async {
    await _supabase
        .from(_requirementsTable)
        .update({
          'is_active': false,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('organization_id', organizationId)
        .eq('id', requirementId);
  }

  void _validateTargets({
    required List<String> functionalRoleIds,
    required List<String> personTypes,
    required List<String> groupIds,
  }) {
    final roles = functionalRoleIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet();
    final types = personTypes
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet();
    final groups = groupIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet();
    if (roles.isEmpty && types.isEmpty && groups.isEmpty) {
      throw ArgumentError(
        'Select at least one Person Type, Functional Role, or Group.',
      );
    }
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw StateError(
      'The Compliance Requirement service returned an invalid response.',
    );
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
