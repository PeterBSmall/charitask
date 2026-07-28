/// Describes the work a person performs.
///
/// Functional Roles define a person's responsibilities,
/// skills, or contributions within the organization.
///
/// A person may have multiple Functional Roles at the
/// same time.
///
/// Examples:
/// • Cashier
/// • Driver
/// • Scheduler
/// • Painter
/// • Crew Leader
/// • Mentor
/// • Donation Processor
class FunctionalRole {
  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Optional description.
  final String? description;

  /// Whether this role is active.
  final bool isActive;

  const FunctionalRole({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });

  FunctionalRole copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return FunctionalRole(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
