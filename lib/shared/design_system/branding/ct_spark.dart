import 'package:flutter/material.dart';

class CTSpark extends StatelessWidget {
  final double size;
  final Color color;

  const CTSpark({
    super.key,
    this.size = 18,
    this.color = const Color(0xFF6C4CF1),
  });

  @override
  Widget build(BuildContext context) {
    final small = size * .55;

    return SizedBox(
      width: size * 1.8,
      height: size * 1.4,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: size * .62,
            child: Icon(Icons.auto_awesome, size: small, color: color),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: Icon(
              Icons.auto_awesome,
              size: small,
              color: color.withValues(alpha: 0.75),
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Icon(
              Icons.auto_awesome,
              size: small,
              color: color.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
