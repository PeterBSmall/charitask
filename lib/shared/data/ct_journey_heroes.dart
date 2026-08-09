import 'package:flutter/material.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

class CTJourneyHeroes {
  CTJourneyHeroes._();

  static const welcome = CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/welcome_people.jpg',
    title: 'Welcome to ChariTask',
    subtitle: 'Technology that helps people serve people.',
    missionTag: 'Built for Mission-Driven Organizations',
  );

  static const organizationSetup = CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/organization_setup.jpg',
    title: 'Organizations create possibility.',
    subtitle: 'Every great mission begins with a strong foundation.',
    missionTag: 'Built for Mission-Driven Organizations',
  );

  static const organizationType = CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/organization_type.png',
    title: 'Every mission is unique.',
    subtitle:
        'The way your organization serves its community helps ChariTask personalize your workspace from day one.',
    missionTag: 'Built for Mission-Driven Organizations',
  );

  static const organizationLocation = CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/welcome_people.jpg',
    title: 'Organizations create possibility.',
    subtitle: 'Every great mission begins with a strong foundation.',
    missionTag: 'Built for Mission-Driven Organizations',
  );

  static const church = CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/faith_group.png',
    title: 'Building faith through service.',
    subtitle:
        'Coordinate ministries, volunteers, events, and outreach—so you can spend more time serving people.',
    missionTag: 'Built for Faith Communities',
  );
}
