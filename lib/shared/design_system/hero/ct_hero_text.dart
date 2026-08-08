import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_journey_hero_data.dart';

class CTHeroText extends StatelessWidget {
  final CTJourneyHeroData hero;
  final List<String> highlights;

  const CTHeroText({super.key, required this.hero, this.highlights = const []});

  @override
  Widget build(BuildContext context) {
    const shadow = [
      Shadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 2)),
    ];

    return Positioned(
      left: 40,
      right: 40,
      bottom: 135,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hero.title,
            style: const TextStyle(
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
            hero.subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(.92),
              fontSize: 18,
              fontWeight: FontWeight.w400,
              height: 1.55,
              shadows: shadow,
            ),
          ),

          if (highlights.isNotEmpty) ...[
            const SizedBox(height: 24),

            Container(
              width: 72,
              height: 1,
              color: Colors.white.withOpacity(.35),
            ),

            const SizedBox(height: 22),

            ...highlights.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 22,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
