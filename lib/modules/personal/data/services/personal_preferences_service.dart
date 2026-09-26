import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalPreferencesService {
  PersonalPreferencesService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  Future<String?> getHeroImageId() async {
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

    final personId = identity['person_id'] as String;

    final preferences = await _supabase
        .from('person_preferences')
        .select('hero_image_id')
        .eq('person_id', personId)
        .maybeSingle();

    return preferences?['hero_image_id'] as String?;
  }

  Future<void> saveHeroImageId(String heroImageId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return;
    }

    final identity = await _supabase
        .from('person_auth_identities')
        .select('person_id')
        .eq('auth_user_id', user.id)
        .maybeSingle();

    if (identity == null) {
      return;
    }

    final personId = identity['person_id'] as String;

    await _supabase.from('person_preferences').upsert({
      'person_id': personId,
      'hero_image_id': heroImageId,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'person_id');
  }
}
