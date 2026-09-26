import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalWorkspaceService {
  PersonalWorkspaceService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  Future<List<Map<String, dynamic>>> getMyPersonalWorkspaces() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return [];
    }

    final identity = await _supabase
        .from('person_auth_identities')
        .select('person_id')
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (identity == null) {
      return [];
    }

    final personId = identity['person_id'] as String;

    final memberships = await _supabase
        .from('workspace_memberships')
        .select('workspace_id')
        .eq('person_id', personId)
        .eq('status', 'active');

    if (memberships.isEmpty) {
      return [];
    }

    final workspaceIds = memberships
        .map((membership) => membership['workspace_id'] as String)
        .toList();

    final workspaces = await _supabase
        .from('workspaces')
        .select('id, name, description, template_id')
        .inFilter('id', workspaceIds)
        .eq('status', 'active')
        .isFilter('archived_at', null)
        .not('template_id', 'is', null);

    return List<Map<String, dynamic>>.from(workspaces);
  }

  Future<bool> hasPersonalWorkspace() async {
    final workspaces = await getMyPersonalWorkspaces();
    return workspaces.isNotEmpty;
  }
}
