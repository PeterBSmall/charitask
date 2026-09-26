import 'package:flutter/material.dart';

import 'hero_image.dart';

class HeroImageLibrary {
  HeroImageLibrary._();

  static const List<HeroImage> all = [
    // COMMUNITY
    HeroImage(
      id: 'community_together',
      name: 'Community Together',
      category: HeroImageCategory.community,
      assetPath: 'assets/images/hero_library/community/community_together.jpg',
      accentColor: Color(0xFF6547E8),
    ),
    HeroImage(
      id: 'community_in_action',
      name: 'Community in Action',
      category: HeroImageCategory.community,
      assetPath: 'assets/images/hero_library/community/community_in_action.jpg',
      accentColor: Color(0xFF0FA3B1),
    ),
    HeroImage(
      id: 'hero_community_volunteers',
      name: 'Community Volunteers',
      category: HeroImageCategory.community,
      assetPath:
          'assets/images/hero_library/community/hero_community_volunteers.jpg',
      accentColor: Color(0xFF4C9A6A),
    ),
    HeroImage(
      id: 'hands_together',
      name: 'Hands Together',
      category: HeroImageCategory.community,
      assetPath: 'assets/images/hero_library/community/hands_together.jpg',
      accentColor: Color(0xFF6547E8),
    ),

    // MISSION & IMPACT
    HeroImage(
      id: 'hero_global_impact',
      name: 'Global Impact',
      category: HeroImageCategory.mission,
      assetPath: 'assets/images/hero_library/impact/hero_global_impact.jpg',
      accentColor: Color(0xFF5878D9),
    ),
    HeroImage(
      id: 'mission_impact_illustrated',
      name: 'Mission Impact',
      category: HeroImageCategory.mission,
      assetPath:
          'assets/images/hero_library/impact/mission_impact_illustrated.png',
      accentColor: Color(0xFFE18A2D),
    ),

    // NATURE & HOPE
    HeroImage(
      id: 'inspiration_mountain_sunrise',
      name: 'Mountain Sunrise',
      category: HeroImageCategory.nature,
      assetPath:
          'assets/images/hero_library/nature/inspiration_mountain_sunrise.png',
      accentColor: Color(0xFF4C9A6A),
    ),

    // SEASONAL / CELEBRATION
    HeroImage(
      id: 'celebration_achievement',
      name: 'Celebration & Achievement',
      category: HeroImageCategory.seasonal,
      assetPath:
          'assets/images/hero_library/Celebration_Achievement/hero_celebration_achievement.jpg',
      accentColor: Color(0xFFE18A2D),
    ),

    // ABSTRACT
    HeroImage(
      id: 'charitask_abstract',
      name: 'ChariTask Abstract',
      category: HeroImageCategory.mission,
      assetPath:
          'assets/images/hero_library/abstract/charitask_background_abstract.png',
      accentColor: Color(0xFF6547E8),
    ),
    HeroImage(
      id: 'purple_geometry',
      name: 'Purple Geometry',
      category: HeroImageCategory.mission,
      assetPath:
          'assets/images/hero_library/abstract/charitask_hero_purple_geometry.png',
      accentColor: Color(0xFF6547E8),
    ),
    HeroImage(
      id: 'navy_orange',
      name: 'Navy & Orange',
      category: HeroImageCategory.mission,
      assetPath:
          'assets/images/hero_library/abstract/charitask_hero_abstract_navy_orange.png',
      accentColor: Color(0xFFE18A2D),
    ),
  ];

  static List<HeroImage> byCategory(HeroImageCategory category) {
    return all.where((image) => image.category == category).toList();
  }

  static HeroImage get defaultImage =>
      all.firstWhere((image) => image.id == 'community_together');
}
