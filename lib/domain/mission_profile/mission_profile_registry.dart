import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';

import 'profiles/nonprofit_profile.dart';
import 'profiles/church_profile.dart';
import 'profiles/business_profile.dart';
import 'profiles/healthcare_profile.dart';
import 'profiles/municipality_profile.dart';
import 'profiles/foundation_profile.dart';
import 'profiles/membership_profile.dart';
import 'profiles/community_profile.dart';
import 'profiles/arts_profile.dart';
import 'profiles/school_profile.dart';

class CTMissionProfiles {
  static const nonprofit = nonprofitProfile;
  static const church = churchProfile;
  static const business = businessProfile;
  static const healthcare = healthcareProfile;
  static const municipality = municipalityProfile;
  static const foundation = foundationProfile;
  static const membership = membershipProfile;
  static const community = communityProfile;
  static const arts = artsProfile;

  static CTMissionProfile fromType(OrganizationType type) {
    switch (type) {
      case OrganizationType.nonprofit:
        return nonprofit;

      case OrganizationType.church:
        return church;

      case OrganizationType.school:
        return schoolProfile;

      case OrganizationType.business:
        return business;

      case OrganizationType.healthcare:
        return healthcare;

      case OrganizationType.municipality:
        return municipality;

      case OrganizationType.foundation:
        return foundation;

      case OrganizationType.association:
        return membership;

      case OrganizationType.communityGroup:
        return community;

      case OrganizationType.artsCulture:
        return arts;

      case OrganizationType.school:
        return nonprofit;

      case OrganizationType.other:
        return nonprofit;
    }
  }
}
