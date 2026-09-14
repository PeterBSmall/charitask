import 'package:flutter/material.dart';

enum HeroImageCategory { community, mission, nature, seasonal }

class HeroImage {
  final String id;
  final String name;
  final HeroImageCategory category;
  final String assetPath;
  final Color accentColor;

  const HeroImage({
    required this.id,
    required this.name,
    required this.category,
    required this.assetPath,
    required this.accentColor,
  });
}
