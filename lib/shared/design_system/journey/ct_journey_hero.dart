import 'package:flutter/material.dart';

class CTJourneyHero extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String subtitle;

  const CTJourneyHero({
    super.key,
    required this.image,
    this.title = 'Welcome to ChariTask',
    this.subtitle =
        'Technology built for organizations that make a difference.',
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: 1.07,
            child: Image(image: image, fit: BoxFit.cover),
          ),

          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.40, 0.70, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(.05),
                  Colors.black.withOpacity(.25),
                  Colors.black.withOpacity(.72),
                ],
              ),
            ),
          ),

          Positioned(
            left: 40,
            right: 40,
            bottom: 90,
            child: _JourneyHeroContent(title: title, subtitle: subtitle),
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
