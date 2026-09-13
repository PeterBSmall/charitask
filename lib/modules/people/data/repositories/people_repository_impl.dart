import '../../domain/repositories/people_repository.dart';

import '../services/people_service.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  PeopleRepositoryImpl(this._service);

  final PeopleService _service;

  @override
  Future<List<Map<String, dynamic>>> getPeople({
    required String organizationId,
  }) {
    return _service.getPeople(organizationId: organizationId);
  }

  @override
  Future<Map<String, dynamic>> createPerson({
    required String organizationId,
    required String firstName,
    required String lastName,
    String? preferredName,
    String? email,
    String? phone,
    String? employmentType,
  }) {
    return _service.createPerson(
      organizationId: organizationId,
      firstName: firstName,
      lastName: lastName,
      preferredName: preferredName,
      email: email,
      phone: phone,
      employmentType: employmentType,
    );
  }

  @override
  Future<void> createOrganizationMembership({
    required String organizationId,
    required String personId,
    required String status,
  }) {
    return _service.createOrganizationMembership(
      organizationId: organizationId,
      personId: personId,
      status: status,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getOrganizationalRoles({
    required String organizationId,
    required String roleCategory,
  }) {
    return _service.getOrganizationalRoles(
      organizationId: organizationId,
      roleCategory: roleCategory,
    );
  }

  @override
  Future<void> createOrganizationalRoleAssignment({
    required String organizationId,
    required String personId,
    required String organizationalRoleId,
    bool isPrimary = true,
  }) {
    return _service.createOrganizationalRoleAssignment(
      organizationId: organizationId,
      personId: personId,
      organizationalRoleId: organizationalRoleId,
      isPrimary: isPrimary,
    );
  }
}
