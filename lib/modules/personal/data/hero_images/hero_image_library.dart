import 'package:flutter/material.dart';

import 'hero_image.dart';

class HeroImageLibrary {
  HeroImageLibrary._();

  static const List<HeroImage> all = [
    // -----------------------------------------------------------------------
    // COMMUNITY
    // -----------------------------------------------------------------------
    HeroImage(
      id: 'community_together',
      name: 'Community Together',
      category: HeroImageCategory.community,
      assetPath: 'assets/images/hero/community_together.jpg',
      accentColor: Color(0xFF6547E8),
    ),

    HeroImage(
      id: 'volunteers_in_action',
      name: 'Volunteers in Action',
      category: HeroImageCategory.community,
      assetPath: 'assets/images/hero/volunteers_in_action.jpg',
      accentColor: Color(0xFF0FA3B1),
    ),

    HeroImage(
      id: 'neighbors_helping',
      name: 'Neighbors Helping Neighbors',
      category: HeroImageCategory.community,
      assetPath: 'assets/images/hero/neighbors_helping.jpg',
      accentColor: Color(0xFF4C9A6A),
    ),

    // -----------------------------------------------------------------------
    // MISSION
    // -----------------------------------------------------------------------
    HeroImage(
      id: 'teamwork',
      name: 'Teamwork',
      category: HeroImageCategory.mission,
      assetPath: 'assets/images/hero/teamwork.jpg',
      accentColor: Color(0xFF5878D9),
    ),

    HeroImage(
      id: 'making_an_impact',
      name: 'Making an Impact',
      category: HeroImageCategory.mission,
      assetPath: 'assets/images/hero/making_an_impact.jpg',
      accentColor: Color(0xFFE18A2D),
    ),

    HeroImage(
      id: 'service_in_action',
      name: 'Service in Action',
      category: HeroImageCategory.mission,
      assetPath: 'assets/images/hero/service_in_action.jpg',
      accentColor: Color(0xFFB94B7B),
    ),

    // -----------------------------------------------------------------------
    // NATURE & HOPE
    // -----------------------------------------------------------------------
    HeroImage(
      id: 'lighthouse',
      name: 'Lighthouse',
      category: HeroImageCategory.nature,
      assetPath: 'assets/images/hero/lighthouse.jpg',
      accentColor: Color(0xFF6547E8),
    ),

    HeroImage(
      id: 'coastal_sunrise',
      name: 'Coastal Sunrise',
      category: HeroImageCategory.nature,
      assetPath: 'assets/images/hero/coastal_sunrise.jpg',
      accentColor: Color(0xFFE18A2D),
    ),

    HeroImage(
      id: 'path_forward',
      name: 'Path Forward',
      category: HeroImageCategory.nature,
      assetPath: 'assets/images/hero/path_forward.jpg',
      accentColor: Color(0xFF4C9A6A),
    ),

    // -----------------------------------------------------------------------
    // SEASONAL
    // -----------------------------------------------------------------------
    HeroImage(
      id: 'spring_community',
      name: 'Spring Community',
      category: HeroImageCategory.seasonal,
      assetPath: 'assets/images/hero/spring_community.jpg',
      accentColor: Color(0xFF7A9E4F),
    ),

    HeroImage(
      id: 'summer_gathering',
      name: 'Summer Gathering',
      category: HeroImageCategory.seasonal,
      assetPath: 'assets/images/hero/summer_gathering.jpg',
      accentColor: Color(0xFFE18A2D),
    ),

    HeroImage(
      id: 'winter_hope',
      name: 'Winter Hope',
      category: HeroImageCategory.seasonal,
      assetPath: 'assets/images/hero/winter_hope.jpg',
      accentColor: Color(0xFF5878D9),
    ),
  ];

  static List<HeroImage> byCategory(HeroImageCategory category) {
    return all.where((image) => image.category == category).toList();
  }

  static HeroImage get defaultImage =>
      all.firstWhere((image) => image.id == 'lighthouse');
}
