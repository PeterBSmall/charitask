/// Defines a specific capability within ChariTask.
///
/// Permissions represent individual actions that may be
/// granted through Permission Tiers or Functional Roles.
///
/// Examples:
/// • people.view
/// • people.create
/// • people.edit
/// • schedules.view
/// • schedules.manage
/// • organization.manage
class Permission {
  /// Unique identifier.
  final String id;

  /// Stable permission key used by the system.
  ///
  /// Example:
  /// people.view
  final String key;

  /// Human-readable display name.
  final String name;

  /// Optional description of what this permission allows.
  final String? description;

  /// Whether this permission is currently active.
  final bool isActive;

  const Permission({
    required this.id,
    required this.key,
    required this.name,
    this.description,
    this.isActive = true,
  });

  Permission copyWith({
    String? id,
    String? key,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return Permission(
      id: id ?? this.id,
      key: key ?? this.key,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
