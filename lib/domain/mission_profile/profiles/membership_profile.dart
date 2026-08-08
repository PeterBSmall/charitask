import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const membershipProfile = CTMissionProfile(
  type: OrganizationType.association,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/membership_photo.png',
    title: 'Strengthening your membership.',
    subtitle:
        'Keep members engaged, manage events, and build lasting relationships from one connected platform.',
  ),

  actionButton: 'Support Our Members',

  examples: [
    'Professional Association',
    'Chamber of Commerce',
    'Trade Association',
    'Sports League',
    'Membership Organization',
  ],
);
