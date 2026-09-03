import 'package:supabase_flutter/supabase_flutter.dart';

class PeopleService {
  PeopleService(this._supabase);

  final SupabaseClient _supabase;

  /// Returns all people the current user is allowed to view
  /// within the specified organization.
  Future<List<Map<String, dynamic>>> getPeople({
    required String organizationId,
  }) async {
    final response = await _supabase
        .from('persons')
        .select()
        .eq('organization_id', organizationId)
        .order('last_name', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Creates a new person within an organization.
  Future<Map<String, dynamic>> createPerson({
    required String organizationId,
    required String firstName,
    required String lastName,
    String? preferredName,
    String? email,
    String? phone,
    String? employmentType,
  }) async {
    final response = await _supabase
        .from('persons')
        .insert({
          'organization_id': organizationId,
          'first_name': firstName,
          'last_name': lastName,
          'preferred_name': preferredName,
          'email': email,
          'phone': phone,
          'employment_type': employmentType,
        })
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }
}
