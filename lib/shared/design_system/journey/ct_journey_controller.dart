import 'package:flutter/material.dart';
import 'package:charitask/domain/organization/organization.dart';
import 'package:charitask/domain/organization/organization_type.dart';
import 'package:charitask/shared/data/ct_journey_heroes.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

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

      default:
        setContextHero(null);
        break;
    }

    notifyListeners();
  }

  void updateOrganizationLocation(String value) {
    organizationLocation = value;
    notifyListeners();
  }

  void setChapterHero(CTJourneyHeroData hero) {
    chapterHero = hero;
    notifyListeners();
  }

  void setContextHero(CTJourneyHeroData? hero) {
    contextHero = hero;
    notifyListeners();
  }
}
