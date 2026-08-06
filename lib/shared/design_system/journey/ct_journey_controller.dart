import 'package:flutter/material.dart';
import 'package:charitask/domain/organization/organization.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/data/ct_journey_heroes.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';
import 'package:charitask/domain/organization/organization_size.dart';
import 'package:charitask/domain/organization/organization_mission.dart';

class CTJourneyController extends ChangeNotifier {
  int currentStep = 0;

  final Organization organization = Organization();
  CTJourneyHeroData chapterHero = CTJourneyHeroes.organizationType;

  CTJourneyHeroData? contextHero;

  CTJourneyHeroData get currentHero => contextHero ?? chapterHero;

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

    switch (value) {
      case OrganizationType.church:
        setContextHero(CTJourneyHeroes.church);
        break;

      case OrganizationType.nonprofit:
        setContextHero(CTJourneyHeroes.organizationType);
        break;

      case OrganizationType.school:
        setContextHero(CTJourneyHeroes.organizationType);
        break;

      case OrganizationType.municipality:
        setContextHero(CTJourneyHeroes.organizationType);
        break;

      case OrganizationType.business:
        setContextHero(CTJourneyHeroes.organizationType);
        break;

      case OrganizationType.healthcare:
        setContextHero(CTJourneyHeroes.organizationType);
        break;

      case OrganizationType.artsCulture:
        setContextHero(CTJourneyHeroes.organizationType);
        break;

      case OrganizationType.foundation:
        setContextHero(CTJourneyHeroes.organizationType);
        break;

      case OrganizationType.association:
        setContextHero(CTJourneyHeroes.organizationType);
        break;

      case OrganizationType.communityGroup:
        setContextHero(CTJourneyHeroes.organizationType);
        break;

      case OrganizationType.other:
        setContextHero(CTJourneyHeroes.organizationType);
        break;
    }

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
}
