import 'package:supabase_flutter/supabase_flutter.dart';

class WorkspaceService {
  WorkspaceService(this._supabase);

  final SupabaseClient _supabase;

  /// Returns all active workspaces belonging to the organization.
  Future<List<Map<String, dynamic>>> getWorkspaces({
    required String organizationId,
  }) async {
    final response = await _supabase
        .from('workspaces')
        .select()
        .eq('organization_id', organizationId)
        .eq('status', 'active')
        .isFilter('archived_at', null)
        .order('name', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Creates a workspace belonging to the specified organization.
  Future<Map<String, dynamic>> createWorkspace({
    required String organizationId,
    required String name,
    required String slug,
    String? description,
  }) async {
    final response = await _supabase
        .from('workspaces')
        .insert({
          'organization_id': organizationId,
          'name': name,
          'slug': slug,
          'description': description,
        })
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }
}
