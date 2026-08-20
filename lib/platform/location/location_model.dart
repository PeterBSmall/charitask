/// Represents a place where work happens.
///
/// Locations belong to a Workspace and provide context for
/// people, groups, projects, and operations.
///
/// A location may represent a building, campus, warehouse,
/// office, construction site, event venue, or any other place
/// where work occurs.
class Location {
  /// Unique identifier.
  final String id;

  /// Workspace this Location belongs to.
  final String workspaceId;

  /// Display name.
  final String name;

  /// Optional description.
  final String? description;

  /// Physical address.
  final String? address;

  /// Contact phone number.
  final String? phone;

  /// Whether this location is currently active.
  final bool isActive;

  const Location({
    required this.id,
    required this.workspaceId,
    required this.name,
    this.description,
    this.address,
    this.phone,
    this.isActive = true,
  });

  Location copyWith({
    String? id,
    String? workspaceId,
    String? name,
    String? description,
    String? address,
    String? phone,
    bool? isActive,
  }) {
    return Location(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
    );
  }
}
