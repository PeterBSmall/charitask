import 'package:flutter/material.dart';
import 'package:charitask/shared/models/ct_journey_hero_data.dart';
import 'package:charitask/shared/design_system/hero/ct_hero_image.dart';
import 'package:charitask/shared/design_system/hero/ct_hero_gradient.dart';
import 'package:charitask/shared/design_system/branding/ct_mission_mark.dart';

class CTHero extends StatelessWidget {
  final CTJourneyHeroData hero;

  const CTHero({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CTHeroImage(hero: hero),

          const CTHeroGradient(),

          Positioned(
            left: 48,
            right: 48,
            bottom: 28,
            child: _JourneyHeroContent(
              title: hero.title,
              subtitle: hero.subtitle,
              missionTag: hero.missionTag,
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
  final String missionTag;

  const _JourneyHeroContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.missionTag,
  });

  @override
  Widget build(BuildContext context) {
    const shadow = [
      Shadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 2)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -0.4,
            shadows: shadow,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(.92),
            fontSize: 19,
            fontWeight: FontWeight.w400,
            height: 1.6,
            shadows: shadow,
          ),
        ),
        const SizedBox(height: 36),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [CTMissionMark(label: missionTag)],
        ),
      ],
    );
  }
}
