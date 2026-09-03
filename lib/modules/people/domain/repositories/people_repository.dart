abstract class PeopleRepository {
  Future<List<Map<String, dynamic>>> getPeople({
    required String organizationId,
  });

  Future<Map<String, dynamic>> createPerson({
    required String organizationId,
    required String firstName,
    required String lastName,
    String? preferredName,
    String? email,
    String? phone,
    String? employmentType,
  });
}
