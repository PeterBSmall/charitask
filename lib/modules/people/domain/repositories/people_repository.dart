abstract class PeopleRepository {
  Future<List<Map<String, dynamic>>> getPeople({
    required String organizationId,
  });

  Future<Map<String, dynamic>?> getPerson({
    required String organizationId,
    required String personId,
  });

  Future<Map<String, dynamic>> createPerson({
    required String organizationId,
    required String firstName,
    required String lastName,
    String? preferredName,
    String? email,
    String? phone,
    String? employmentType,
    String? personType,
    String? notes,
  });

  Future<Map<String, dynamic>> updatePerson({
    required String organizationId,
    required String personId,
    required String firstName,
    required String lastName,
    String? preferredName,
    String? email,
    String? phone,
    String? employmentType,
    String? personType,
    String? notes,
    required String status,
  });

  Future<void> createOrganizationMembership({
    required String organizationId,
    required String personId,
    required String status,
  });

  Future<List<Map<String, dynamic>>> getOrganizationalRoles({
    required String organizationId,
    required String roleCategory,
  });

  Future<void> createOrganizationalRoleAssignment({
    required String organizationId,
    required String personId,
    required String organizationalRoleId,
    bool isPrimary = true,
  });
}
