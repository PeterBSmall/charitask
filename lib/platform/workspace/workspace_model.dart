/// Represents an operational workspace within an organization.
///
/// A Workspace belongs to one Organization and provides a
/// context for groups, memberships, modules, and operational work.
///
/// A person may belong to multiple Workspaces.
class Workspace {
  /// Unique identifier.
  final String id;

  /// Organization that owns this Workspace.
  final String organizationId;

  /// Display name.
  final String name;

  const Workspace({
    required this.id,
    required this.organizationId,
    required this.name,
  });

  Workspace copyWith({String? id, String? organizationId, String? name}) {
    return Workspace(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
    );
  }
}
