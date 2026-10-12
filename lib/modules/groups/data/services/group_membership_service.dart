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
membership_role,
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
    String membershipRole = 'member',
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();

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
            'membership_role': membershipRole,
            'started_at': now,
            'ended_at': null,
            'updated_at': now,
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
      'membership_role': membershipRole,
    });
  }

  Future<void> addMembers({
    required String organizationId,
    required String groupId,
    required Map<String, String> memberRoles,
  }) async {
    for (final entry in memberRoles.entries) {
      await addMember(
        organizationId: organizationId,
        groupId: groupId,
        personId: entry.key,
        membershipRole: entry.value,
      );
    }
  }

  Future<void> updateMemberRole({
    required String organizationId,
    required String groupId,
    required String personId,
    required String membershipRole,
  }) async {
    const allowedRoles = {'leader', 'co_leader', 'coordinator', 'member'};

    if (!allowedRoles.contains(membershipRole)) {
      throw ArgumentError.value(
        membershipRole,
        'membershipRole',
        'Unsupported group membership role.',
      );
    }

    final now = DateTime.now().toUtc().toIso8601String();

    await _supabase
        .from('group_memberships')
        .update({'membership_role': membershipRole, 'updated_at': now})
        .eq('organization_id', organizationId)
        .eq('group_id', groupId)
        .eq('person_id', personId)
        .eq('status', 'active');
  }

  Future<void> removeMember({
    required String organizationId,
    required String groupId,
    required String personId,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await _supabase
        .from('group_memberships')
        .update({'status': 'inactive', 'ended_at': now, 'updated_at': now})
        .eq('organization_id', organizationId)
        .eq('group_id', groupId)
        .eq('person_id', personId)
        .eq('status', 'active');
  }
}
