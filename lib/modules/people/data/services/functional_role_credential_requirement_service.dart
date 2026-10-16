import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/domain/models/functional_role_credential_requirement.dart';
import 'package:charitask/modules/people/domain/models/person_credential.dart';

class FunctionalRoleCredentialRequirementService {
  FunctionalRoleCredentialRequirementService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  static const String _table = 'functional_role_credential_requirements';

  /// Loads requirements configured for one Functional Role.
  Future<List<FunctionalRoleCredentialRequirement>> getForRole({
    required String organizationId,
    required String functionalRoleId,
  }) async {
    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .eq('functional_role_id', functionalRoleId)
        .order('credential_category')
        .order('credential_name');

    return List<Map<String, dynamic>>.from(
      rows,
    ).map(FunctionalRoleCredentialRequirement.fromMap).toList();
  }

  /// Loads requirements for several Functional Roles in one query.
  ///
  /// Returns an empty list without querying when roleIds is empty.
  Future<List<FunctionalRoleCredentialRequirement>> getForRoles({
    required String organizationId,
    required List<String> roleIds,
  }) async {
    if (roleIds.isEmpty) return [];

    final rows = await _supabase
        .from(_table)
        .select()
        .eq('organization_id', organizationId)
        .inFilter('functional_role_id', roleIds)
        .order('credential_category')
        .order('credential_name');

    return List<Map<String, dynamic>>.from(
      rows,
    ).map(FunctionalRoleCredentialRequirement.fromMap).toList();
  }

  /// Creates a requirement for an existing role in the organization.
  Future<FunctionalRoleCredentialRequirement> create({
    required String organizationId,
    required String functionalRoleId,
    required CredentialCategory category,
    String? credentialName,
    String? description,
  }) async {
    final row = await _supabase
        .from(_table)
        .insert({
          'organization_id': organizationId,
          'functional_role_id': functionalRoleId,
          'credential_category': category.value,
          'credential_name': _nullableText(credentialName),
          'description': _nullableText(description),
        })
        .select()
        .single();

    return FunctionalRoleCredentialRequirement.fromMap(
      Map<String, dynamic>.from(row),
    );
  }

  /// Updates an existing requirement without changing its identity.
  Future<FunctionalRoleCredentialRequirement> update({
    required String organizationId,
    required String functionalRoleId,
    required String requirementId,
    required CredentialCategory category,
    String? credentialName,
    String? description,
  }) async {
    final row = await _supabase
        .from(_table)
        .update({
          'credential_category': category.value,
          'credential_name': _nullableText(credentialName),
          'description': _nullableText(description),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('organization_id', organizationId)
        .eq('functional_role_id', functionalRoleId)
        .eq('id', requirementId)
        .select()
        .single();

    return FunctionalRoleCredentialRequirement.fromMap(
      Map<String, dynamic>.from(row),
    );
  }

  /// Deletes a requirement. Database RLS enforces authorization.
  Future<void> delete({
    required String organizationId,
    required String functionalRoleId,
    required String requirementId,
  }) async {
    await _supabase
        .from(_table)
        .delete()
        .eq('organization_id', organizationId)
        .eq('functional_role_id', functionalRoleId)
        .eq('id', requirementId);
  }

  String? _nullableText(String? value) {
    final cleaned = value?.trim();
    return cleaned == null || cleaned.isEmpty ? null : cleaned;
  }
}
