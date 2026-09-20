import 'package:supabase_flutter/supabase_flutter.dart';

class AuthorizationService {
  AuthorizationService(this._supabase);

  final SupabaseClient _supabase;

  /// Returns whether the currently authenticated person has the
  /// specified permission within the organization.
  ///
  /// The database function is the source of truth for authorization.
  Future<bool> hasPermission({
    required String organizationId,
    required String permissionKey,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return false;
    }

    final identity = await _supabase
        .from('person_auth_identities')
        .select('person_id')
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (identity == null) {
      return false;
    }

    final personId = identity['person_id'] as String?;

    if (personId == null || personId.isEmpty) {
      return false;
    }

    final result = await _supabase.rpc(
      'has_organization_permission',
      params: {
        'p_person_id': personId,
        'p_organization_id': organizationId,
        'p_permission_key': permissionKey,
      },
    );

    return result == true;
  }
}
