import 'package:flutter/material.dart';

class ProfileHeroPanel extends StatelessWidget {
  const ProfileHeroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2F197C), Color(0xFF4B2DB7), Color(0xFF5E38D5)],
        ),
      ),
      child: Stack(
        children: [
          // Soft abstract background.
          const Positioned.fill(
            child: CustomPaint(painter: _ProfileHeroGraphicPainter()),
          ),

          // ChariTask branding.
          Positioned(
            top: 38,
            left: 38,
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'C',
                    style: TextStyle(
                      color: Color(0xFF4B2DB7),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'ChariTask',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Main message.
          Positioned(
            left: 38,
            right: 38,
            bottom: 118,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your profile is\npart of the mission.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.7,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'Tell ChariTask a little more about you so your '
                  'experience can feel personal from day one.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Bottom callout.
          Positioned(
            left: 38,
            right: 38,
            bottom: 36,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.white.withValues(alpha: 0.90),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your profile helps ChariTask tailor your experience.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.94),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeroGraphicPainter extends CustomPainter {
  const _ProfileHeroGraphicPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Large soft circular form.
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.07);

    canvas.drawCircle(
      Offset(width * 0.82, height * 0.20),
      width * 0.48,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(width * 0.15, height * 0.17),
      width * 0.11,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(width * 0.88, height * 0.72),
      width * 0.17,
      circlePaint,
    );

    // Soft flowing shape.
    final wavePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.08);

    final path = Path();

    path.moveTo(-20, height * 0.30);

    path.cubicTo(
      width * 0.22,
      height * 0.16,
      width * 0.38,
      height * 0.46,
      width * 0.62,
      height * 0.36,
    );

    path.cubicTo(
      width * 0.83,
      height * 0.27,
      width * 0.87,
      height * 0.48,
      width + 30,
      height * 0.40,
    );

    canvas.drawPath(path, wavePaint);

    final secondPath = Path();

    secondPath.moveTo(-30, height * 0.60);

    secondPath.cubicTo(
      width * 0.18,
      height * 0.48,
      width * 0.33,
      height * 0.73,
      width * 0.55,
      height * 0.62,
    );

    secondPath.cubicTo(
      width * 0.74,
      height * 0.52,
      width * 0.88,
      height * 0.76,
      width + 30,
      height * 0.66,
    );

    canvas.drawPath(secondPath, wavePaint);

    // Very soft filled glow shapes.
    final glowPaint = Paint()..color = Colors.white.withValues(alpha: 0.025);

    canvas.drawCircle(
      Offset(width * 0.75, height * 0.12),
      width * 0.38,
      glowPaint,
    );

    canvas.drawCircle(
      Offset(width * 0.12, height * 0.82),
      width * 0.34,
      glowPaint,
    );

    // Small sparkle accents.
    _drawSparkle(canvas, Offset(width * 0.49, height * 0.18), 7);

    _drawSparkle(canvas, Offset(width * 0.28, height * 0.27), 5);

    _drawSparkle(canvas, Offset(width * 0.84, height * 0.34), 4);

    _drawSparkle(canvas, Offset(width * 0.12, height * 0.47), 6);
  }

  void _drawSparkle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(center.dx, center.dy - radius);
    path.quadraticBezierTo(
      center.dx + radius * 0.25,
      center.dy - radius * 0.25,
      center.dx + radius,
      center.dy,
    );
    path.quadraticBezierTo(
      center.dx + radius * 0.25,
      center.dy + radius * 0.25,
      center.dx,
      center.dy + radius,
    );
    path.quadraticBezierTo(
      center.dx - radius * 0.25,
      center.dy + radius * 0.25,
      center.dx - radius,
      center.dy,
    );
    path.quadraticBezierTo(
      center.dx - radius * 0.25,
      center.dy - radius * 0.25,
      center.dx,
      center.dy - radius,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
