class FoundationSetupProgress {
  final bool organizationProfile;
  final bool organizationType;
  final bool primaryLocation;
  final bool additionalLocations;
  final bool peopleAndEmployees;
  final bool rolesAndPermissions;
  final bool brandIdentity;

  const FoundationSetupProgress({
    required this.organizationProfile,
    required this.organizationType,
    required this.primaryLocation,
    required this.additionalLocations,
    required this.peopleAndEmployees,
    required this.rolesAndPermissions,
    required this.brandIdentity,
  });

  int get completedCount {
    return [
      organizationProfile,
      organizationType,
      primaryLocation,
      additionalLocations,
      peopleAndEmployees,
      rolesAndPermissions,
      brandIdentity,
    ].where((complete) => complete).length;
  }

  int get totalCount => 7;

  double get progress => completedCount / totalCount;

  String get percentage => '${(progress * 100).round()}%';
}
