import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const nonprofitProfile = CTMissionProfile(
  type: OrganizationType.nonprofit,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/nonprofit_photo.png',
    title: 'Every mission is unique.',
    subtitle:
        'The way your organization serves its community helps ChariTask personalize your workspace from day one.',
  ),

  actionButton: 'Start My Mission',

  examples: [
    'Habitat for Humanity',
    'Food Bank',
    'Youth Program',
    'Community Services',
    'Advocacy Organization',
  ],
);
