/// Represents an organization-owned physical or operational location.
///
/// Locations provide context for people, groups, workspaces,
/// schedules, programs, and other organizational operations.
class Location {
  /// Unique identifier.
  final String id;

  /// Organization that owns this location.
  final String organizationId;

  /// Display name.
  final String name;

  /// URL/database-safe identifier.
  final String slug;

  /// Optional description.
  final String? description;

  /// Type of location.
  final String? locationType;

  /// Address line 1.
  final String? addressLine1;

  /// Address line 2.
  final String? addressLine2;

  /// City.
  final String? city;

  /// State or province.
  final String? state;

  /// Postal/ZIP code.
  final String? postalCode;

  /// Country code.
  final String? country;

  /// ChariTask Person assigned as the location manager.
  final String? locationManagerPersonId;

  /// ChariTask Person assigned as the primary contact.
  final String? primaryContactPersonId;

  /// Legacy/external contact name.
  ///
  /// Retained for compatibility with existing location data.
  final String? contactName;

  /// Role or relationship of the primary contact to this location.
  final String? contactRole;

  /// Main phone number for this location.
  final String? phone;

  /// Main phone extension for this location.
  final String? phoneExtension;

  /// General email address for this location.
  final String? email;

  /// Direct phone number for the primary contact.
  final String? contactPhone;

  /// Phone extension for the primary contact.
  final String? contactPhoneExtension;

  /// Maximum building capacity.
  final int? buildingCapacity;

  /// Number of available parking spaces.
  final int? parkingSpaces;

  /// Maximum volunteer capacity.
  final int? volunteerCapacity;

  /// Geographic latitude.
  final double? latitude;

  /// Geographic longitude.
  final double? longitude;

  /// IANA timezone identifier.
  final String? timezone;

  /// Internal notes visible to authorized organization users.
  final String? internalNotes;

  /// Whether the location is active.
  final bool isActive;

  /// When the location was created.
  final DateTime? createdAt;

  /// When the location was last updated.
  final DateTime? updatedAt;

  /// When the location was archived.
  final DateTime? archivedAt;

  const Location({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.slug,
    this.description,
    this.locationType,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.locationManagerPersonId,
    this.primaryContactPersonId,
    this.contactName,
    this.contactRole,
    this.phone,
    this.phoneExtension,
    this.email,
    this.contactPhone,
    this.contactPhoneExtension,
    this.buildingCapacity,
    this.parkingSpaces,
    this.volunteerCapacity,
    this.latitude,
    this.longitude,
    this.timezone,
    this.internalNotes,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.archivedAt,
  });

  /// Creates a Location from a Supabase row.
  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      name: map['name'] as String,
      slug: map['slug'] as String,
      description: map['description'] as String?,
      locationType: map['location_type'] as String?,
      addressLine1: map['address_line_1'] as String?,
      addressLine2: map['address_line_2'] as String?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      postalCode: map['postal_code'] as String?,
      country: map['country'] as String?,
      locationManagerPersonId: map['location_manager_person_id'] as String?,
      primaryContactPersonId: map['primary_contact_person_id'] as String?,
      contactName: map['contact_name'] as String?,
      contactRole: map['contact_role'] as String?,
      phone: map['phone'] as String?,
      phoneExtension: map['phone_extension'] as String?,
      email: map['email'] as String?,
      contactPhone: map['contact_phone'] as String?,
      contactPhoneExtension: map['contact_phone_extension'] as String?,
      buildingCapacity: _parseInt(map['building_capacity']),
      parkingSpaces: _parseInt(map['parking_spaces']),
      volunteerCapacity: _parseInt(map['volunteer_capacity']),
      latitude: _parseDouble(map['latitude']),
      longitude: _parseDouble(map['longitude']),
      timezone: map['timezone'] as String?,
      internalNotes: map['internal_notes'] as String?,
      isActive: (map['status'] as String? ?? 'active') == 'active',
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
      archivedAt: _parseDateTime(map['archived_at']),
    );
  }

  /// Converts this Location to a Supabase insert/update map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'country': country,
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
      'status': isActive ? 'active' : 'inactive',
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'archived_at': archivedAt?.toIso8601String(),
    };
  }

  Location copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? slug,
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
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? archivedAt,
  }) {
    return Location(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      locationType: locationType ?? this.locationType,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      locationManagerPersonId:
          locationManagerPersonId ?? this.locationManagerPersonId,
      primaryContactPersonId:
          primaryContactPersonId ?? this.primaryContactPersonId,
      contactName: contactName ?? this.contactName,
      contactRole: contactRole ?? this.contactRole,
      phone: phone ?? this.phone,
      phoneExtension: phoneExtension ?? this.phoneExtension,
      email: email ?? this.email,
      contactPhone: contactPhone ?? this.contactPhone,
      contactPhoneExtension:
          contactPhoneExtension ?? this.contactPhoneExtension,
      buildingCapacity: buildingCapacity ?? this.buildingCapacity,
      parkingSpaces: parkingSpaces ?? this.parkingSpaces,
      volunteerCapacity: volunteerCapacity ?? this.volunteerCapacity,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      internalNotes: internalNotes ?? this.internalNotes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }

  String get fullAddress {
    final parts = [
      addressLine1,
      addressLine2,
      city,
      state,
      postalCode,
      country,
    ].where((part) => part != null && part.trim().isNotEmpty);

    return parts.join(', ');
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value;
    }

    return DateTime.tryParse(value.toString());
  }
}
