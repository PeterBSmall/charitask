import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/foundation/domain/models/location.dart';

class LocationService {
  final SupabaseClient _supabase;

  LocationService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<List<Location>> getLocations({required String organizationId}) async {
    final rows = await _supabase
        .from('locations')
        .select()
        .eq('organization_id', organizationId)
        .eq('status', 'active')
        .isFilter('archived_at', null)
        .order('name');

    return rows
        .map((row) => Location.fromMap(Map<String, dynamic>.from(row)))
        .toList();
  }

  Future<Location?> getLocation({
    required String locationId,
    required String organizationId,
  }) async {
    final row = await _supabase
        .from('locations')
        .select()
        .eq('id', locationId)
        .eq('organization_id', organizationId)
        .maybeSingle();

    if (row == null) return null;

    return Location.fromMap(Map<String, dynamic>.from(row));
  }

  Future<List<Map<String, dynamic>>> getLocationCategoryTags({
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from('organization_location_category_tags')
        .select()
        .eq('organization_id', organizationId)
        .eq('status', 'active')
        .isFilter('archived_at', null)
        .order('name');

    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  Future<List<String>> getLocationTagIds({
    required String locationId,
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from('location_category_tag_assignments')
        .select('tag_id')
        .eq('organization_id', organizationId)
        .eq('location_id', locationId);

    return rows.map((row) => row['tag_id'] as String).toList();
  }

  Future<Location> createLocation({
    required String organizationId,
    required String name,
    required String slug,
    String? description,
    String? locationType,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? locationManagerPersonId,
    String? primaryContactPersonId,
    String? contactName,
    String? phone,
    String? email,
    int? buildingCapacity,
    int? parkingSpaces,
    int? volunteerCapacity,
    double? latitude,
    double? longitude,
    String? timezone,
    String? internalNotes,
    List<String> tagIds = const [],
  }) async {
    final row = await _supabase
        .from('locations')
        .insert({
          'organization_id': organizationId,
          'name': name,
          'slug': slug,
          'description': description,
          'location_type': locationType,
          'address_line_1': addressLine1,
          'address_line_2': addressLine2,
          'city': city,
          'state': state,
          'postal_code': postalCode,
          'country': country ?? 'US',
          'location_manager_person_id': locationManagerPersonId,
          'primary_contact_person_id': primaryContactPersonId,
          'contact_name': contactName,
          'phone': phone,
          'email': email,
          'building_capacity': buildingCapacity,
          'parking_spaces': parkingSpaces,
          'volunteer_capacity': volunteerCapacity,
          'latitude': latitude,
          'longitude': longitude,
          'timezone': timezone,
          'internal_notes': internalNotes,
        })
        .select()
        .single();

    final location = Location.fromMap(Map<String, dynamic>.from(row));

    await _replaceLocationTags(
      organizationId: organizationId,
      locationId: location.id,
      tagIds: tagIds,
    );

    return location;
  }

  Future<Location> updateLocation({
    required String locationId,
    required String organizationId,
    required Map<String, dynamic> changes,
    List<String>? tagIds,
  }) async {
    final row = await _supabase
        .from('locations')
        .update({...changes, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', locationId)
        .eq('organization_id', organizationId)
        .select()
        .single();

    if (tagIds != null) {
      await _replaceLocationTags(
        organizationId: organizationId,
        locationId: locationId,
        tagIds: tagIds,
      );
    }

    return Location.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> archiveLocation({
    required String locationId,
    required String organizationId,
  }) async {
    await _supabase
        .from('locations')
        .update({
          'status': 'inactive',
          'archived_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', locationId)
        .eq('organization_id', organizationId);
  }

  Future<void> _replaceLocationTags({
    required String organizationId,
    required String locationId,
    required List<String> tagIds,
  }) async {
    await _supabase
        .from('location_category_tag_assignments')
        .delete()
        .eq('organization_id', organizationId)
        .eq('location_id', locationId);

    if (tagIds.isEmpty) return;

    final assignments = tagIds
        .map(
          (tagId) => {
            'organization_id': organizationId,
            'location_id': locationId,
            'tag_id': tagId,
          },
        )
        .toList();

    await _supabase
        .from('location_category_tag_assignments')
        .insert(assignments);
  }
}
