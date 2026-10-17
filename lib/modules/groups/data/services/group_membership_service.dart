import 'package:supabase_flutter/supabase_flutter.dart';

class GroupMembershipService {
  final SupabaseClient _supabase;

  GroupMembershipService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  /// Loads a person's group memberships, including historical periods
  /// when [activeOnly] is false.
  Future<List<Map<String, dynamic>>> getPersonMemberships({
    required String organizationId,
    required String personId,
    bool activeOnly = true,
  }) async {
    var query = _supabase
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
          groups (
            id,
            name,
            description,
            group_type,
            color,
            location_id,
            status
          )
        ''')
        .eq('organization_id', organizationId)
        .eq('person_id', personId);

    if (activeOnly) {
      query = query.eq('status', 'active');
    }

    final rows = await query.order('started_at', ascending: false);

    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  /// Ends one specific membership without deleting its history.
  Future<void> endMembership({
    required String organizationId,
    required String membershipId,
    String? updatedByPersonId,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await _supabase
        .from('group_memberships')
        .update({
          'status': 'inactive',
          'ended_at': now,
          'updated_at': now,
          'updated_by_person_id': updatedByPersonId,
        })
        .eq('organization_id', organizationId)
        .eq('id', membershipId)
        .eq('status', 'active');
  }

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
    final existingActive = await _supabase
        .from('group_memberships')
        .select('id')
        .eq('organization_id', organizationId)
        .eq('group_id', groupId)
        .eq('person_id', personId)
        .eq('status', 'active')
        .maybeSingle();

    if (existingActive != null) return;

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
