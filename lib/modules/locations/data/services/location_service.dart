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

  Future<List<Map<String, dynamic>>> getPersonLocationAssignments({
    required String organizationId,
    required String personId,
    bool activeOnly = true,
  }) async {
    var query = _supabase
        .from('person_locations')
        .select('''
          id,
          organization_id,
          person_id,
          location_id,
          status,
          is_primary,
          started_at,
          ended_at,
          created_at,
          updated_at,
          locations (
            id,
            name,
            location_type,
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

  Future<void> assignPersonToLocation({
    required String organizationId,
    required String personId,
    required String locationId,
    bool makePrimary = false,
    String? createdByPersonId,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();

    final activeAssignment = await _supabase
        .from('person_locations')
        .select('id')
        .eq('organization_id', organizationId)
        .eq('person_id', personId)
        .eq('location_id', locationId)
        .eq('status', 'active')
        .maybeSingle();

    if (activeAssignment != null) {
      if (makePrimary) {
        await _supabase
            .from('person_locations')
            .update({'is_primary': false, 'updated_at': now})
            .eq('organization_id', organizationId)
            .eq('person_id', personId)
            .eq('status', 'active')
            .eq('is_primary', true);

        await _supabase
            .from('person_locations')
            .update({'is_primary': true, 'updated_at': now})
            .eq('organization_id', organizationId)
            .eq('id', activeAssignment['id']);
      }

      return;
    }

    if (makePrimary) {
      await _supabase
          .from('person_locations')
          .update({'is_primary': false, 'updated_at': now})
          .eq('organization_id', organizationId)
          .eq('person_id', personId)
          .eq('status', 'active')
          .eq('is_primary', true);
    }

    await _supabase.from('person_locations').insert({
      'organization_id': organizationId,
      'person_id': personId,
      'location_id': locationId,
      'status': 'active',
      'is_primary': makePrimary,
      'created_by_person_id': createdByPersonId,
    });
  }

  Future<void> endPersonLocationAssignment({
    required String organizationId,
    required String assignmentId,
    String? updatedByPersonId,
  }) async {
    final now = DateTime.now().toUtc().toIso8601String();

    await _supabase
        .from('person_locations')
        .update({
          'status': 'inactive',
          'ended_at': now,
          'updated_at': now,
          'updated_by_person_id': updatedByPersonId,
        })
        .eq('organization_id', organizationId)
        .eq('id', assignmentId)
        .eq('status', 'active');
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
    bool isActive = true,
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
    String? contactRole,
    String? phone,
    String? phoneExtension,
    String? email,
    String? contactPhone,
    String? contactPhoneExtension,
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
          'contact_role': contactRole,
          'phone': phone,
          'phone_extension': phoneExtension,
          'email': email,
          'contact_phone': contactPhone,
          'contact_phone_extension': contactPhoneExtension,
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
