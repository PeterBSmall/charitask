import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const artsProfile = CTMissionProfile(
  type: OrganizationType.artsCulture,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/art_photo.png',
    title: 'Creativity inspires community.',
    subtitle:
        'Coordinate artists, volunteers, events, exhibits, and programs that bring people together.',
  ),

  actionButton: 'Inspire Our Community',

  highlights: [
    'Programs & Workshops',
    'Events & Exhibits',
    'Artist & Volunteer Coordination',
  ],
);
