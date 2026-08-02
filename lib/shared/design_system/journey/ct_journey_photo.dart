import 'package:flutter/material.dart';

class CTJourneyPhoto extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String caption;

  const CTJourneyPhoto({
    super.key,
    required this.image,
    this.title = 'Welcome to ChariTask',
    this.caption = 'Technology built for organizations that make a difference.',
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
            bottom: 40,
            child: _JourneyPhotoCaption(title: title, caption: caption),
          ),
        ],
      ),
    );
  }
}

class _JourneyPhotoCaption extends StatelessWidget {
  final String title;
  final String caption;

  const _JourneyPhotoCaption({required this.title, required this.caption});

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
          caption,
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
