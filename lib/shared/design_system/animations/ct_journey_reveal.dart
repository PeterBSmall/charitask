import 'package:flutter/material.dart';

class CTJourneyReveal extends StatelessWidget {
  final bool visible;
  final Widget child;
  final Duration duration;
  final Curve curve;

  const CTJourneyReveal({
    super.key,
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 650),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: duration,
      curve: curve,
      offset: visible ? Offset.zero : const Offset(0, 0.08),
      child: AnimatedOpacity(
        duration: duration,
        curve: curve,
        opacity: visible ? 1 : 0,
        child: child,
      ),
    );
  }
}
