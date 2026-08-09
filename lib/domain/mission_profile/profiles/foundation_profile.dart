import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const foundationProfile = CTMissionProfile(
  type: OrganizationType.foundation,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/foundation_photo.png',
    title: 'Fueling missions that matter.',
    subtitle:
        'Evaluate grants, collaborate with partners, and maximize the impact of every investment.',
    missionTag: 'Built for Grantmaking',
  ),

  actionButton: 'Fund Great Work',

  highlights: ['Grant Management', 'Funding Programs', 'Impact Measurement'],
);
