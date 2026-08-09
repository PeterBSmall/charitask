import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const businessProfile = CTMissionProfile(
  type: OrganizationType.business,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/business_photo.png',
    title: 'Great teams build great organizations.',
    subtitle:
        'Bring employees, projects, communication, and operations together in one connected workspace.',
    missionTag: 'Built for Purpose-Driven Teams',
  ),

  actionButton: 'Build My Team',

  highlights: [
    'Employee Management',
    'Team Scheduling',
    'Projects & Communication',
  ],
);
