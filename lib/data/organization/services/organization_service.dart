import 'package:supabase_flutter/supabase_flutter.dart';

class OrganizationService {
  OrganizationService(this._supabase);

  final SupabaseClient _supabase;

  /// Creates a new organization and returns the persisted record.
  Future<Map<String, dynamic>> createOrganization({
    required String name,
    required String slug,
  }) async {
    final response = await _supabase
        .from('organizations')
        .insert({'name': name, 'slug': slug})
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }
}
