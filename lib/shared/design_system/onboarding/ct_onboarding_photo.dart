import 'package:flutter/material.dart';

class CTOnboardingPhoto extends StatelessWidget {
  final ImageProvider image;

  const CTOnboardingPhoto({super.key, required this.image});

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

          const Positioned(
            left: 40,
            right: 40,
            bottom: 40,
            child: _PhotoCaption(),
          ),
        ],
      ),
    );
  }
}

class _PhotoCaption extends StatelessWidget {
  const _PhotoCaption();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to ChariTask',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 12),

        Text(
          'Technology built for organizations that make a difference.',
          style: TextStyle(color: Colors.white70, fontSize: 18, height: 1.5),
        ),
      ],
    );
  }
}
