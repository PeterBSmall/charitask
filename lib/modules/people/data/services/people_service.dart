import 'package:supabase_flutter/supabase_flutter.dart';

class PeopleService {
  PeopleService(this._supabase);

  final SupabaseClient _supabase;

  /// Returns all people the current user is allowed to view.
  Future<List<Map<String, dynamic>>> getPeople() async {
    final response = await _supabase
        .from('people')
        .select()
        .order('last_name', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }
}
