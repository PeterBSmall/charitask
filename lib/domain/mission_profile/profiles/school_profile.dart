import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

const schoolProfile = CTMissionProfile(
  type: OrganizationType.school,

  hero: CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/school_photo.png',
    title: 'Learning builds stronger communities.',
    subtitle:
        'Coordinate staff, volunteers, students, events, and programs from one connected workspace.',
    missionTag: 'Built for Educational Communities',
  ),

  actionButton: 'Build Our School',

  highlights: ['Staff Coordination', 'School Events', 'Student Programs'],
);
