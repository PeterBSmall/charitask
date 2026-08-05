import 'package:flutter/material.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';

class CTJourneyHeroes {
  CTJourneyHeroes._();

  static const welcome = CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/welcome_people.jpg',
    title: 'Welcome to ChariTask',
    subtitle: 'Technology built for organizations that make a difference.',
  );

  static const organizationSetup = CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/organization_setup.jpg',
    title: 'Organizations create possibility.',
    subtitle: 'Every great mission begins with a strong foundation.',
  );

  static const organizationType = CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/organization_type.png',
    title: 'Every mission is unique.',
    subtitle:
        'The way your organization serves its community helps ChariTask personalize your workspace from day one.',
  );

  static const organizationLocation = CTJourneyHeroData(
    imageAsset: 'assets/images/onboarding/welcome_people.jpg',
    title: 'Organizations create possibility.',
    subtitle: 'Every great mission begins with a strong foundation.',
  );
}
