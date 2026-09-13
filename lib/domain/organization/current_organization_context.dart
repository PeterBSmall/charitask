import 'package:supabase_flutter/supabase_flutter.dart';

class CurrentOrganizationContext {
  CurrentOrganizationContext(this._supabase);

  final SupabaseClient _supabase;

  Future<String?> getOrganizationId() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final identity = await _supabase
        .from('person_auth_identities')
        .select('person_id')
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (identity == null) {
      return null;
    }

    final personId = identity['person_id'] as String?;

    if (personId == null || personId.isEmpty) {
      return null;
    }

    final membership = await _supabase
        .from('organization_memberships')
        .select('organization_id')
        .eq('person_id', personId)
        .eq('status', 'active')
        .maybeSingle();

    if (membership == null) {
      return null;
    }

    return membership['organization_id'] as String?;
  }
}
