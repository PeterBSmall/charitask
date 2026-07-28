/// Represents a place where work happens.
///
/// Locations provide context for people,
/// groups, projects, and operations.
///
/// A location may represent a building,
/// campus, warehouse, office, construction site,
/// event venue, or any other place where work occurs.
class Location {
  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Optional description.
  final String? description;

  /// Physical address.
  final String? address;

  /// Contact phone number.
  final String? phone;

  /// Whether this location is active.
  final bool isActive;

  const Location({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.phone,
    this.isActive = true,
  });

  Location copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? phone,
    bool? isActive,
  }) {
    return Location(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
    );
  }
}
