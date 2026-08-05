import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_journey_hero_data.dart';

class CTHeroImage extends StatelessWidget {
  final CTJourneyHeroData hero;

  const CTHeroImage({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Transform.scale(
        scale: hero.imageScale,
        child: Image.asset(
          hero.imageAsset,
          alignment: hero.alignment,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
