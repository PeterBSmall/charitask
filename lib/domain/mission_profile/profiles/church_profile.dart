import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const churchProfile = CTMissionProfile(
  type: OrganizationType.church,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/faith_group.png',
    title: 'Building faith through service.',
    subtitle:
        'Coordinate ministries, volunteers, events, and outreach—so you can spend more time serving people.',
  ),

  actionButton: 'Start Our Ministry',

  highlights: [
    'Ministry Management',
    'Volunteer Coordination',
    'Worship & Events',
  ],
);
