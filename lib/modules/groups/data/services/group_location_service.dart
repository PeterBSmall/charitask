import 'package:supabase_flutter/supabase_flutter.dart';

class GroupLocationService {
  final SupabaseClient _supabase;

  GroupLocationService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  /// Returns the active locations associated with a group.
  Future<List<Map<String, dynamic>>> getLocations({
    required String organizationId,
    required String groupId,
  }) async {
    final rows = await _supabase
        .from('group_locations')
        .select('''
          id,
          organization_id,
          group_id,
          location_id,
          created_at,
          created_by_person_id,
          locations(
            id,
            name,
            description,
            location_type,
            status,
            archived_at
          )
        ''')
        .eq('organization_id', organizationId)
        .eq('group_id', groupId)
        .order('created_at');

    return rows.map((row) => Map<String, dynamic>.from(row)).where((row) {
      final location = row['locations'];
      if (location is! Map<String, dynamic>) {
        return false;
      }

      return location['status'] == 'active' && location['archived_at'] == null;
    }).toList();
  }

  /// Associates a location with a group.
  Future<void> addLocation({
    required String organizationId,
    required String groupId,
    required String locationId,
    String? createdByPersonId,
  }) async {
    final existing = await _supabase
        .from('group_locations')
        .select('id')
        .eq('organization_id', organizationId)
        .eq('group_id', groupId)
        .eq('location_id', locationId)
        .maybeSingle();

    if (existing != null) {
      return;
    }

    await _supabase.from('group_locations').insert({
      'organization_id': organizationId,
      'group_id': groupId,
      'location_id': locationId,
      if (createdByPersonId case final personId?)
        'created_by_person_id': personId,
    });
  }

  /// Removes a location association from a group.
  Future<void> removeLocation({
    required String organizationId,
    required String groupId,
    required String locationId,
  }) async {
    await _supabase
        .from('group_locations')
        .delete()
        .eq('organization_id', organizationId)
        .eq('group_id', groupId)
        .eq('location_id', locationId);
  }

  /// Replaces all location associations for a group.
  Future<void> setLocations({
    required String organizationId,
    required String groupId,
    required List<String> locationIds,
    String? createdByPersonId,
  }) async {
    final existing = await _supabase
        .from('group_locations')
        .select('location_id')
        .eq('organization_id', organizationId)
        .eq('group_id', groupId);

    final existingIds = existing
        .map((row) => row['location_id'] as String)
        .toSet();

    final selectedIds = locationIds.toSet();

    final locationsToRemove = existingIds.difference(selectedIds);
    final locationsToAdd = selectedIds.difference(existingIds);

    for (final locationId in locationsToRemove) {
      await removeLocation(
        organizationId: organizationId,
        groupId: groupId,
        locationId: locationId,
      );
    }

    for (final locationId in locationsToAdd) {
      await addLocation(
        organizationId: organizationId,
        groupId: groupId,
        locationId: locationId,
        createdByPersonId: createdByPersonId,
      );
    }
  }
}
