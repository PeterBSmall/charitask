import 'package:supabase_flutter/supabase_flutter.dart';

class PersonPrivateDetailsService {
  final SupabaseClient _supabase;

  PersonPrivateDetailsService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  /// Creates or updates the protected details for a person.
  ///
  /// dateOfBirth is stored as a calendar date, without a time component.
  /// informationProviderType must be one of:
  /// self, parent_guardian, authorized_representative, organization_staff.

  /// Loads only the fields needed to calculate age eligibility.
  /// Supabase RLS remains responsible for enforcing access.
  Future<List<Map<String, dynamic>>> getOrganizationPrivateDetails({
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from('person_private_details')
        .select('person_id, date_of_birth')
        .eq('organization_id', organizationId);

    return List<Map<String, dynamic>>.from(rows);
  }

  Future<void> savePrivateDetails({
    required String organizationId,
    required String personId,
    required DateTime? dateOfBirth,
    required String informationProviderType,
    String? providerName,
    String? providerRelationship,
  }) async {
    final cleanProviderName = providerName?.trim();
    final cleanProviderRelationship = providerRelationship?.trim();

    final dateValue = dateOfBirth == null
        ? null
        : '${dateOfBirth.year.toString().padLeft(4, '0')}-'
              '${dateOfBirth.month.toString().padLeft(2, '0')}-'
              '${dateOfBirth.day.toString().padLeft(2, '0')}';

    await _supabase.from('person_private_details').upsert({
      'organization_id': organizationId,
      'person_id': personId,
      'date_of_birth': dateValue,
      'information_provider_type': informationProviderType,
      'provider_name': cleanProviderName == null || cleanProviderName.isEmpty
          ? null
          : cleanProviderName,
      'provider_relationship':
          cleanProviderRelationship == null || cleanProviderRelationship.isEmpty
          ? null
          : cleanProviderRelationship,
    }, onConflict: 'organization_id,person_id');
  }

  Future<Map<String, dynamic>?> getPersonPrivateDetails({
    required String organizationId,
    required String personId,
  }) async {
    final response = await _supabase
        .from('person_private_details')
        .select(
          'date_of_birth, information_provider_type, '
          'provider_name, provider_relationship',
        )
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Map<String, dynamic>.from(response);
  }
}
