/// Represents a collection of people working together.
///
/// Groups organize people around a common purpose,
/// project, department, committee, ministry, or team.
///
/// Groups are intentionally flexible and may represent
/// permanent or temporary collaborations.
class Group {
  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Optional description.
  final String? description;

  /// Whether this group is active.
  final bool isActive;

  const Group({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
