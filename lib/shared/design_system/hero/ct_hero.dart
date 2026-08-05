import 'package:flutter/material.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';
import 'package:charitask/shared/design_system/hero/ct_hero_image.dart';
import 'package:charitask/shared/design_system/hero/ct_hero_gradient.dart';
import 'package:charitask/shared/design_system/hero/ct_hero.dart';

class CTHero extends StatelessWidget {
  final CTJourneyHeroData hero;

  const CTHero({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    debugPrint('------------------------------');
    debugPrint('CTHero');
    debugPrint('Title : ${hero.title}');
    debugPrint('Image : ${hero.imageAsset}');

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CTHeroImage(hero: hero),

          const CTHeroGradient(),

          Positioned(
            left: 40,
            right: 40,
            bottom: 90,
            child: _JourneyHeroContent(
              title: hero.title,
              subtitle: hero.subtitle,
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyHeroContent extends StatelessWidget {
  final String title;
  final String subtitle;

  const _JourneyHeroContent({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    const shadow = [
      Shadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 2)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -0.4,
            shadows: shadow,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(.92),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1.55,
            shadows: shadow,
          ),
        ),
      ],
    );
  }
}
