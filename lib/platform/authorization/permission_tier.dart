/// Defines a reusable level of system access.
///
/// Permission Tiers group permissions into a named
/// access level. They describe what a person is
/// allowed to do, independent of the work they perform
/// or their relationship to the organization.
///
/// Examples:
/// • Viewer
/// • Member
/// • Manager
/// • Administrator
/// • Owner
class PermissionTier {
  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Optional description.
  final String? description;

  /// Whether this permission tier is currently active.
  final bool isActive;

  const PermissionTier({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });

  PermissionTier copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return PermissionTier(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
