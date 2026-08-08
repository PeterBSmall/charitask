import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const municipalityProfile = CTMissionProfile(
  type: OrganizationType.municipality,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/municipality_photo.png',
    title: 'Serving communities together.',
    subtitle:
        'Coordinate departments, staff, volunteers, and community initiatives from one shared platform.',
  ),

  actionButton: 'Serve My Community',

  highlights: [
    'Department Coordination',
    'Community Services',
    'Events & Public Engagement',
  ],
);
