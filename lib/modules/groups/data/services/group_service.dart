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

    final groups = rows
        .map((row) => _fromMap(Map<String, dynamic>.from(row)))
        .toList();

    if (groups.isEmpty) {
      return groups;
    }

    final counts = await _getMemberCounts(
      organizationId: organizationId,
      groupIds: groups.map((group) => group.id).toList(),
    );

    return groups
        .map((group) => group.copyWith(memberCount: counts[group.id] ?? 0))
        .toList();
  }

  Future<List<Group>> getArchivedGroups({
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from('groups')
        .select()
        .eq('organization_id', organizationId)
        .eq('status', 'inactive')
        .not('archived_at', 'is', null)
        .order('archived_at', ascending: false);

    final groups = rows
        .map((row) => _fromMap(Map<String, dynamic>.from(row)))
        .toList();

    if (groups.isEmpty) {
      return groups;
    }

    final counts = await _getMemberCounts(
      organizationId: organizationId,
      groupIds: groups.map((group) => group.id).toList(),
    );

    return groups
        .map((group) => group.copyWith(memberCount: counts[group.id] ?? 0))
        .toList();
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

    final group = _fromMap(Map<String, dynamic>.from(row));

    final counts = await _getMemberCounts(
      organizationId: organizationId,
      groupIds: [groupId],
    );

    return group.copyWith(memberCount: counts[groupId] ?? 0);
  }

  Future<Group> createGroup({
    required String organizationId,
    required String name,
    required String slug,
    required GroupType groupType,
    required GroupVisibility visibility,
    required GroupOwnerType ownerType,
    required String ownerId,
    required List<GroupMembershipType> membershipComposition,
    String? description,
    String? locationId,
    String color = '#06B6D4',
    String? createdByPersonId,
  }) async {
    final row = await _supabase
        .from('groups')
        .insert({
          'organization_id': organizationId,
          'name': name,
          'slug': slug,
          'description': description,
          'group_type': groupType.value,
          'visibility': visibility.value,
          'owner_type': ownerType.value,
          'owner_id': ownerId,
          'membership_composition': membershipComposition
              .map((type) => type.value)
              .toList(),
          'location_id': locationId,
          'color': color,
          'created_by_person_id': createdByPersonId,
        })
        .select()
        .single();

    return _fromMap(Map<String, dynamic>.from(row));
  }

  /// Creates a new group based on an existing group.
  ///
  /// Preserves the group's configuration but deliberately does not copy
  /// membership records. Generates a unique slug within the organization.
  Future<Group> duplicateGroup({
    required String organizationId,
    required Group sourceGroup,
    required String name,
    required String? description,
  }) async {
    final groupType = sourceGroup.groupType;
    final ownerType = sourceGroup.ownerType;
    final ownerId = sourceGroup.ownerId;

    // Preserve the original ownership instead of silently changing it.
    if (groupType == null || ownerType == null || ownerId == null) {
      throw StateError(
        'This group is missing its type or ownership information '
        'and cannot be duplicated safely.',
      );
    }

    // Include archived groups because slug uniqueness applies to all
    // groups in the organization, not only active groups.
    final rows = await _supabase
        .from('groups')
        .select('slug')
        .eq('organization_id', organizationId);

    final existingSlugs = rows
        .map((row) => (row['slug'] as String?)?.toLowerCase())
        .whereType<String>()
        .toSet();

    final normalizedName = name.trim();

    final baseSlug = normalizedName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    final rootSlug = baseSlug.isEmpty ? 'group' : baseSlug;

    var slug = rootSlug;
    var suffix = 2;

    while (existingSlugs.contains(slug.toLowerCase())) {
      slug = '$rootSlug-$suffix';
      suffix++;
    }

    final cleanDescription = description?.trim();

    return createGroup(
      organizationId: organizationId,
      name: normalizedName,
      slug: slug,
      groupType: groupType,
      visibility: sourceGroup.visibility,
      ownerType: ownerType,
      ownerId: ownerId,
      membershipComposition: sourceGroup.membershipComposition,
      description: cleanDescription == null || cleanDescription.isEmpty
          ? null
          : cleanDescription,
      locationId: sourceGroup.locationId,
      color: sourceGroup.color,
    );
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

    final group = _fromMap(Map<String, dynamic>.from(row));

    final counts = await _getMemberCounts(
      organizationId: organizationId,
      groupIds: [groupId],
    );

    return group.copyWith(memberCount: counts[groupId] ?? 0);
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

  Future<void> restoreGroup({
    required String groupId,
    required String organizationId,
  }) async {
    await _supabase
        .from('groups')
        .update({
          'status': 'active',
          'archived_at': null,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', groupId)
        .eq('organization_id', organizationId)
        .select('id')
        .single();
  }

  Future<Map<String, int>> _getMemberCounts({
    required String organizationId,
    required List<String> groupIds,
  }) async {
    if (groupIds.isEmpty) {
      return {};
    }

    final rows = await _supabase
        .from('group_memberships')
        .select('group_id')
        .eq('organization_id', organizationId)
        .eq('status', 'active')
        .inFilter('group_id', groupIds);

    final counts = <String, int>{};

    for (final row in rows) {
      final groupId = row['group_id'] as String;
      counts[groupId] = (counts[groupId] ?? 0) + 1;
    }

    return counts;
  }

  Group _fromMap(Map<String, dynamic> row) {
    final composition =
        (row['membership_composition'] as List<dynamic>?)
            ?.map((value) => GroupMembershipType.fromValue(value.toString()))
            .whereType<GroupMembershipType>()
            .toList() ??
        const <GroupMembershipType>[];

    return Group(
      id: row['id'] as String,
      organizationId: row['organization_id'] as String,
      name: row['name'] as String,
      description: row['description'] as String?,
      groupType: GroupType.fromValue(row['group_type'] as String?),
      visibility: GroupVisibility.fromValue(row['visibility'] as String?),
      ownerType: GroupOwnerType.fromValue(row['owner_type'] as String?),
      ownerId: row['owner_id'] as String?,
      membershipComposition: composition,
      locationId: row['location_id'] as String?,
      status: row['status'] as String? ?? 'active',
      createdByPersonId: row['created_by_person_id'] as String?,
      createdAt: _parseDateTime(row['created_at']),
      updatedAt: _parseDateTime(row['updated_at']),
      color: row['color'] as String? ?? '#06B6D4',
      isActive: row['status'] == 'active' && row['archived_at'] == null,
      tags: const [],
    );
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}
