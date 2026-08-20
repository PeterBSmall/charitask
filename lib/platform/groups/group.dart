/// Represents a collection of people working together.
///
/// Groups belong to a Workspace and organize people around
/// a common purpose, project, department, committee, ministry,
/// or team.
///
/// Groups are intentionally flexible and may represent
/// permanent or temporary collaborations.
class Group {
  /// Unique identifier.
  final String id;

  /// Workspace this Group belongs to.
  final String workspaceId;

  /// Display name.
  final String name;

  /// Optional description.
  final String? description;

  /// Whether this group is currently active.
  final bool isActive;

  const Group({
    required this.id,
    required this.workspaceId,
    required this.name,
    this.description,
    this.isActive = true,
  });

  Group copyWith({
    String? id,
    String? workspaceId,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return Group(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
