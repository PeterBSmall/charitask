import 'package:supabase_flutter/supabase_flutter.dart';

class GroupMembershipService {
  final SupabaseClient _supabase;

  GroupMembershipService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getMembers({
    required String organizationId,
    required String groupId,
  }) async {
    final rows = await _supabase
        .from('group_memberships')
        .select('''
          id,
          organization_id,
          group_id,
          person_id,
          status,
          started_at,
          ended_at,
          persons(
            id,
            first_name,
            last_name,
            preferred_name,
            email,
            phone
          )
        ''')
        .eq('organization_id', organizationId)
        .eq('group_id', groupId)
        .eq('status', 'active')
        .order('started_at');

    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  Future<void> addMember({
    required String organizationId,
    required String groupId,
    required String personId,
  }) async {
    final existing = await _supabase
        .from('group_memberships')
        .select('id')
        .eq('organization_id', organizationId)
        .eq('group_id', groupId)
        .eq('person_id', personId)
        .maybeSingle();

    if (existing != null) {
      await _supabase
          .from('group_memberships')
          .update({
            'status': 'active',
            'started_at': DateTime.now().toIso8601String(),
            'ended_at': null,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', existing['id'])
          .eq('organization_id', organizationId);

      return;
    }

    await _supabase.from('group_memberships').insert({
      'organization_id': organizationId,
      'group_id': groupId,
      'person_id': personId,
      'status': 'active',
    });
  }

  Future<void> removeMember({
    required String organizationId,
    required String groupId,
    required String personId,
  }) async {
    await _supabase
        .from('group_memberships')
        .update({
          'status': 'inactive',
          'ended_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('organization_id', organizationId)
        .eq('group_id', groupId)
        .eq('person_id', personId)
        .eq('status', 'active');
  }
}
