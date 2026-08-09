import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const healthcareProfile = CTMissionProfile(
  type: OrganizationType.healthcare,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/healthcare_photo.png',
    title: 'Care begins with connection.',
    subtitle:
        'Coordinate caregivers, volunteers, schedules, and patient-focused programs from one secure workspace.',
    missionTag: 'Built for Care Teams',
  ),

  actionButton: 'Start Caring',

  highlights: [
    'Care Team Coordination',
    'Volunteer Management',
    'Scheduling & Patient Programs',
  ],
);
