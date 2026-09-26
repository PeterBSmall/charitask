import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/groups/domain/models/group.dart';

class GroupService {
  final SupabaseClient _supabase;

  GroupService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<List<Group>> getGroups({required String organizationId}) async {
    final rows = await _supabase
        .from('groups')
        .select()
        .eq('organization_id', organizationId)
        .eq('status', 'active')
        .isFilter('archived_at', null)
        .order('name');

    return rows.map((row) => _fromMap(Map<String, dynamic>.from(row))).toList();
  }

  Future<Group?> getGroup({
    required String groupId,
    required String organizationId,
  }) async {
    final row = await _supabase
        .from('groups')
        .select()
        .eq('id', groupId)
        .eq('organization_id', organizationId)
        .maybeSingle();

    if (row == null) return null;

    return _fromMap(Map<String, dynamic>.from(row));
  }

  Future<Group> createGroup({
    required String organizationId,
    required String name,
    required String slug,
    String? description,
  }) async {
    final row = await _supabase
        .from('groups')
        .insert({
          'organization_id': organizationId,
          'name': name,
          'slug': slug,
          'description': description,
        })
        .select()
        .single();

    return _fromMap(Map<String, dynamic>.from(row));
  }

  Future<Group> updateGroup({
    required String groupId,
    required String organizationId,
    required Map<String, dynamic> changes,
  }) async {
    final row = await _supabase
        .from('groups')
        .update({...changes, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', groupId)
        .eq('organization_id', organizationId)
        .select()
        .single();

    return _fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> archiveGroup({
    required String groupId,
    required String organizationId,
  }) async {
    await _supabase
        .from('groups')
        .update({
          'status': 'inactive',
          'archived_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', groupId)
        .eq('organization_id', organizationId);
  }

  Group _fromMap(Map<String, dynamic> row) {
    return Group(
      id: row['id'] as String,
      organizationId: row['organization_id'] as String,
      name: row['name'] as String,
      description: row['description'] as String?,
      isActive: row['status'] == 'active' && row['archived_at'] == null,
    );
  }
}
