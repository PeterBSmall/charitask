import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const communityProfile = CTMissionProfile(
  type: OrganizationType.communityGroup,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/community_photo.png',
    title: 'Communities grow together.',
    subtitle:
        'Bring neighbors, volunteers, and local initiatives together to make a lasting difference.',
    missionTag: 'Built for Community Impact',
  ),

  actionButton: 'Grow Our Community',

  highlights: ['Community Projects', 'Volunteer Coordination', 'Local Events'],
);
