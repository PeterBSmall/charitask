import 'package:flutter/material.dart';

class CTJourneyHeroData {
  const CTJourneyHeroData({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.missionTag,

    this.overlayOpacity = .45,
    this.alignment = Alignment.center,
    this.imageScale = 1.0,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final String missionTag;

  final double overlayOpacity;
  final Alignment alignment;
  final double imageScale;

  ImageProvider get image => AssetImage(imageAsset);
}
