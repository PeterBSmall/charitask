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
          Image(image: image, fit: BoxFit.cover),

          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(.12),
                  Colors.black.withOpacity(.45),
                ],
              ),
            ),
          ),

          Positioned(
            left: 40,
            right: 40,
            bottom: 60,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
