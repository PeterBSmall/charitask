import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/people/domain/models/person_credential.dart';

class PersonCredentialService {
  final SupabaseClient _supabase;

  PersonCredentialService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  /// Loads credentials visible to the current user across an organization.
  ///
  /// Supabase RLS determines which credential records are returned,
  /// including restricted background-check records.
  Future<List<PersonCredential>> getOrganizationCredentials({
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from('person_credentials')
        .select()
        .eq('organization_id', organizationId)
        .order('person_id')
        .order('category')
        .order('credential_name');

    return List<Map<String, dynamic>>.from(
      rows,
    ).map(PersonCredential.fromMap).toList();
  }

  Future<List<PersonCredential>> getPersonCredentials({
    required String organizationId,
    required String personId,
  }) async {
    final rows = await _supabase
        .from('person_credentials')
        .select()
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .order('category')
        .order('credential_name');

    return List<Map<String, dynamic>>.from(
      rows,
    ).map(PersonCredential.fromMap).toList();
  }

  Future<PersonCredential> createCredential({
    required String organizationId,
    required String personId,
    required PersonCredentialDraft credential,
  }) async {
    final row = await _supabase
        .from('person_credentials')
        .insert(
          credential.toInsertMap(
            organizationId: organizationId,
            personId: personId,
          ),
        )
        .select()
        .single();

    return PersonCredential.fromMap(Map<String, dynamic>.from(row));
  }

  Future<List<PersonCredential>> createCredentials({
    required String organizationId,
    required String personId,
    required List<PersonCredentialDraft> credentials,
  }) async {
    if (credentials.isEmpty) return [];

    final rows = await _supabase
        .from('person_credentials')
        .insert(
          credentials
              .map(
                (credential) => credential.toInsertMap(
                  organizationId: organizationId,
                  personId: personId,
                ),
              )
              .toList(),
        )
        .select();

    return List<Map<String, dynamic>>.from(
      rows,
    ).map(PersonCredential.fromMap).toList();
  }

  Future<PersonCredential> updateCredential({
    required String organizationId,
    required String personId,
    required String credentialId,
    required PersonCredentialDraft credential,
  }) async {
    final row = await _supabase
        .from('person_credentials')
        .update({
          ...credential.toUpdateMap(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .eq('id', credentialId)
        .select()
        .single();

    return PersonCredential.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> deleteCredential({
    required String organizationId,
    required String personId,
    required String credentialId,
  }) async {
    await _supabase
        .from('person_credentials')
        .delete()
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .eq('id', credentialId);
  }
}
