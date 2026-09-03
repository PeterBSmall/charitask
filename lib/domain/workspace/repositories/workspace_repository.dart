abstract class WorkspaceRepository {
  Future<List<Map<String, dynamic>>> getWorkspaces({
    required String organizationId,
  });

  Future<Map<String, dynamic>> createWorkspace({
    required String organizationId,
    required String name,
    required String slug,
    String? description,
  });
}
