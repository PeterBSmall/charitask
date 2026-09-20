import 'package:supabase_flutter/supabase_flutter.dart';

class CurrentPersonService {
  CurrentPersonService(this._supabase);

  final SupabaseClient _supabase;

  Future<String?> getPersonId() async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null || userId.isEmpty) {
      return null;
    }

    final response = await _supabase
        .from('person_auth_identities')
        .select('person_id')
        .eq('auth_user_id', userId)
        .maybeSingle();

    return response?['person_id'] as String?;
  }
}
