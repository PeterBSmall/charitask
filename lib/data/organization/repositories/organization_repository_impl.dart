import '../../../domain/organization/repositories/organization_repository.dart';
import '../services/organization_service.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  OrganizationRepositoryImpl(this._service);

  final OrganizationService _service;

  @override
  Future<Map<String, dynamic>> createOrganization({
    required String name,
    required String slug,
  }) {
    return _service.createOrganization(name: name, slug: slug);
  }
}
