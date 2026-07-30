class WorkspaceContext {
  final String workspaceId;
  final String personId;
  final String organizationId;

  final List<String> roles;
  final List<String> groups;
  final List<String> locations;

  final Map<String, dynamic> state;

  const WorkspaceContext({
    required this.workspaceId,
    required this.personId,
    required this.organizationId,
    this.roles = const [],
    this.groups = const [],
    this.locations = const [],
    this.state = const {},
  });
}
