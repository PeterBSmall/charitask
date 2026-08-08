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
  ),

  actionButton: 'Grow Our Community',

  examples: [
    'Neighborhood Group',
    'Community Coalition',
    'Civic Organization',
    'Local Initiative',
    'Volunteer Group',
  ],
);
