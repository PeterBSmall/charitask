import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const environmentalProfile = CTMissionProfile(
  type: OrganizationType.environmental,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/environmental_photo.png',
    title: 'Protecting tomorrow starts today.',
    subtitle:
        'Coordinate volunteers, restoration projects, cleanups, and environmental initiatives from one shared workspace.',
  ),

  actionButton: 'Protect Our Environment',

  examples: [
    'Conservation Organization',
    'Land Trust',
    'Watershed Association',
    'Environmental Coalition',
    'Climate Initiative',
  ],
);
