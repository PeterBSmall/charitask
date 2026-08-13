class FoundationSetupProgress {
  final bool organizationProfile;
  final bool organizationType;
  final bool primaryLocation;
  final bool additionalLocations;
  final bool peopleAndEmployees;
  final bool rolesAndPermissions;
  final bool brandIdentity;

  const FoundationSetupProgress({
    this.organizationProfile = false,
    this.organizationType = false,
    this.primaryLocation = false,
    this.additionalLocations = false,
    this.peopleAndEmployees = false,
    this.rolesAndPermissions = false,
    this.brandIdentity = false,
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

  int get totalSteps => 7;

  double get progress => completedCount / totalSteps;
}
