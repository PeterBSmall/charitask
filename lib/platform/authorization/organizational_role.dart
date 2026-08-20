/// Describes how a person relates to an organization.
///
/// Organizational Roles define the person's relationship
/// with the organization rather than the work they perform.
///
/// Examples:
/// • Employee
/// • Volunteer
/// • Board Member
/// • Contractor
/// • Intern
class OrganizationalRole {
  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Optional description.
  final String? description;

  /// Whether this role is currently active.
  final bool isActive;

  const OrganizationalRole({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });

  OrganizationalRole copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return OrganizationalRole(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
