import 'package:flutter/material.dart';

class CTHeroGradient extends StatelessWidget {
  const CTHeroGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.40, 0.70, 1.0],
          colors: [
            Colors.transparent,
            Color.fromRGBO(0, 0, 0, .05),
            Color.fromRGBO(0, 0, 0, .25),
            Color.fromRGBO(0, 0, 0, .72),
          ],
        ),
      ),
    );
  }
}
