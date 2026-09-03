abstract class OrganizationRepository {
  Future<Map<String, dynamic>> createOrganization({
    required String name,
    required String slug,
  });
}
