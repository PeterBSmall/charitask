import 'package:supabase_flutter/supabase_flutter.dart';

class LocationOperatingHours {
  final String id;
  final String organizationId;
  final String locationId;
  final int dayOfWeek;
  final bool isClosed;
  final String? opensAt;
  final String? closesAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdByPersonId;
  final String? updatedByPersonId;

  const LocationOperatingHours({
    required this.id,
    required this.organizationId,
    required this.locationId,
    required this.dayOfWeek,
    required this.isClosed,
    this.opensAt,
    this.closesAt,
    this.createdAt,
    this.updatedAt,
    this.createdByPersonId,
    this.updatedByPersonId,
  });

  factory LocationOperatingHours.fromMap(Map<String, dynamic> map) {
    return LocationOperatingHours(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      locationId: map['location_id'] as String,
      dayOfWeek: map['day_of_week'] as int,
      isClosed: map['is_closed'] as bool? ?? false,
      opensAt: map['opens_at'] as String?,
      closesAt: map['closes_at'] as String?,
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
      createdByPersonId: map['created_by_person_id'] as String?,
      updatedByPersonId: map['updated_by_person_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization_id': organizationId,
      'location_id': locationId,
      'day_of_week': dayOfWeek,
      'is_closed': isClosed,
      'opens_at': opensAt,
      'closes_at': closesAt,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'created_by_person_id': createdByPersonId,
      'updated_by_person_id': updatedByPersonId,
    };
  }

  LocationOperatingHours copyWith({
    String? id,
    String? organizationId,
    String? locationId,
    int? dayOfWeek,
    bool? isClosed,
    String? opensAt,
    String? closesAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdByPersonId,
    String? updatedByPersonId,
  }) {
    return LocationOperatingHours(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      locationId: locationId ?? this.locationId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isClosed: isClosed ?? this.isClosed,
      opensAt: opensAt ?? this.opensAt,
      closesAt: closesAt ?? this.closesAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdByPersonId: createdByPersonId ?? this.createdByPersonId,
      updatedByPersonId: updatedByPersonId ?? this.updatedByPersonId,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}

class LocationOperatingHoursService {
  final SupabaseClient _supabase;

  LocationOperatingHoursService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<List<LocationOperatingHours>> getOperatingHours({
    required String locationId,
    required String organizationId,
  }) async {
    final rows = await _supabase
        .from('location_operating_hours')
        .select()
        .eq('location_id', locationId)
        .eq('organization_id', organizationId)
        .order('day_of_week');

    return rows
        .map(
          (row) =>
              LocationOperatingHours.fromMap(Map<String, dynamic>.from(row)),
        )
        .toList();
  }

  Future<LocationOperatingHours> saveDay({
    required String organizationId,
    required String locationId,
    required int dayOfWeek,
    required bool isClosed,
    String? opensAt,
    String? closesAt,
  }) async {
    final row = await _supabase
        .from('location_operating_hours')
        .upsert({
          'organization_id': organizationId,
          'location_id': locationId,
          'day_of_week': dayOfWeek,
          'is_closed': isClosed,
          'opens_at': isClosed ? null : opensAt,
          'closes_at': isClosed ? null : closesAt,
        }, onConflict: 'location_id,day_of_week')
        .select()
        .single();

    return LocationOperatingHours.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> deleteDay({
    required String locationId,
    required String organizationId,
    required int dayOfWeek,
  }) async {
    await _supabase
        .from('location_operating_hours')
        .delete()
        .eq('location_id', locationId)
        .eq('organization_id', organizationId)
        .eq('day_of_week', dayOfWeek);
  }

  Future<void> clearAll({
    required String locationId,
    required String organizationId,
  }) async {
    await _supabase
        .from('location_operating_hours')
        .delete()
        .eq('location_id', locationId)
        .eq('organization_id', organizationId);
  }
}
