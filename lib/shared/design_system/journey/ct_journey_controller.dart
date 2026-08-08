import 'package:flutter/material.dart';
import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/domain/mission_profile/mission_profile_registry.dart';
import 'package:charitask/domain/organization/organization.dart';
import 'package:charitask/domain/organization/organization_mission.dart';
import 'package:charitask/domain/organization/organization_size.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/data/ct_journey_heroes.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

class CTJourneyController extends ChangeNotifier {
  int currentStep = 0;

  final Organization organization = Organization();

  /// Hero assigned to the current onboarding chapter.
  CTJourneyHeroData chapterHero = CTJourneyHeroes.organizationType;

  /// Optional hero that temporarily overrides the chapter hero.
  CTJourneyHeroData? contextHero;

  /// Mission profile selected by the organization type.
  CTMissionProfile missionProfile = CTMissionProfiles.nonprofit;

  CTJourneyHeroData get currentHero {
    if (contextHero != null) {
      return contextHero!;
    }

    // From the organization selection onward, use the mission profile hero.
    if (currentStep >= 2) {
      return missionProfile.hero;
    }

    return chapterHero;
  }

  String organizationLocation = '';
  String firstName = '';

  void updateFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  void nextStep() {
    currentStep++;
    notifyListeners();
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void updateOrganizationName(String value) {
    organization.identity.name = value;
    notifyListeners();
  }

  void updateOrganizationType(OrganizationType value) {
    organization.identity.type = value;

    setMissionProfile(CTMissionProfiles.fromType(value));

    notifyListeners();
  }

  void updateOrganizationSize(OrganizationSize value) {
    organization.identity.size = value;
    notifyListeners();
  }

  void updateOrganizationMission(OrganizationMission value) {
    organization.identity.mission = value;
    notifyListeners();
  }

  void updateOrganizationLocation(String value) {
    organizationLocation = value;
    notifyListeners();
  }

  void setChapterHero(CTJourneyHeroData hero) {
    debugPrint('setChapterHero -> ${hero.title}');
    chapterHero = hero;
    notifyListeners();
  }

  void setContextHero(CTJourneyHeroData? hero) {
    debugPrint('setContextHero -> ${hero?.title ?? "NULL"}');
    contextHero = hero;
    notifyListeners();
  }

  void setMissionProfile(CTMissionProfile profile) {
    missionProfile = profile;
    notifyListeners();
  }
}
