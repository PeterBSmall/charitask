import 'package:charitask/domain/workspace/repositories/workspace_repository.dart';
import 'package:charitask/data/workspace/services/workspace_service.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  WorkspaceRepositoryImpl(this._service);

  final WorkspaceService _service;

  @override
  Future<List<Map<String, dynamic>>> getWorkspaces({
    required String organizationId,
  }) {
    return _service.getWorkspaces(organizationId: organizationId);
  }

  @override
  Future<Map<String, dynamic>> createWorkspace({
    required String organizationId,
    required String name,
    required String slug,
    String? description,
  }) {
    return _service.createWorkspace(
      organizationId: organizationId,
      name: name,
      slug: slug,
      description: description,
    );
  }
}
