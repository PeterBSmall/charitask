import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/mission_profile/profiles/nonprofit_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';

class CTMissionProfiles {
  static const nonprofit = nonprofitProfile;

  static CTMissionProfile fromType(OrganizationType type) {
    switch (type) {
      case OrganizationType.nonprofit:
        return nonprofit;

      default:
        return nonprofit;
    }
  }
}
