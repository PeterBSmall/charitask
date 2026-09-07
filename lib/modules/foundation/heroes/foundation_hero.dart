import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class FoundationHero extends StatelessWidget {
  final CTJourneyController journeyController;

  const FoundationHero({super.key, required this.journeyController});

  @override
  Widget build(BuildContext context) {
    final firstName = journeyController.firstName.trim().isEmpty
        ? 'there'
        : journeyController.firstName.trim();

    return Container(
      width: double.infinity,
      height: 248,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17152F), Color(0xFF24204A), Color(0xFF4D32D5)],
          stops: [0.0, 0.48, 1.0],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _FoundationHeroBackground()),

          Padding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 800;

                if (compact) {
                  return _buildCompactContent(firstName);
                }

                return Row(
                  children: [
                    Expanded(flex: 6, child: _buildContent(firstName)),
                    const SizedBox(width: 24),
                    const Expanded(flex: 4, child: _OrganizationIllustration()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String firstName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWorkspacePill(),
        const SizedBox(height: 18),
        Text(
          '$firstName, your organization is active and running smoothly.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 31,
            height: 1.18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'You’ve built a strong foundation. Now you can manage people, '
          'locations, and teams all in one place.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            height: 1.45,
            fontWeight: FontWeight.w500,
            color: Color(0xFFDCD9F5),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactContent(String firstName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWorkspacePill(),
        const SizedBox(height: 12),
        Text(
          '$firstName, your organization is active and running smoothly.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 25,
            height: 1.18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'You’ve built a strong foundation. Now you can manage people, '
          'locations, and teams all in one place.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, height: 1.4, color: Color(0xFFDCD9F5)),
        ),
      ],
    );
  }

  Widget _buildWorkspacePill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
              color: Color(0xFF9BD36A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          const Text(
            'ORGANIZATION WORKSPACE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.35,
              color: Color(0xFFE8E6F7),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoundationHeroBackground extends StatelessWidget {
  const _FoundationHeroBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _FoundationHeroBackgroundPainter());
  }
}

class _FoundationHeroBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 70
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF673EFF).withValues(alpha: 0.38);

    final rect = Rect.fromCenter(
      center: Offset(size.width * 0.72, size.height * 0.35),
      width: size.width * 0.85,
      height: size.height * 2.3,
    );

    canvas.drawArc(rect, math.pi * 0.82, math.pi * 0.55, false, paint);

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..color = const Color(0xFF8A5CFF).withValues(alpha: 0.18);

    final glowRect = Rect.fromCenter(
      center: Offset(size.width * 0.73, size.height * 0.40),
      width: size.width * 0.65,
      height: size.height * 1.7,
    );

    canvas.drawArc(glowRect, math.pi * 0.82, math.pi * 0.55, false, glow);

    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.75);

    _drawStar(
      canvas,
      Offset(size.width * 0.66, size.height * 0.45),
      9,
      starPaint,
    );

    _drawStar(
      canvas,
      Offset(size.width * 0.92, size.height * 0.43),
      8,
      starPaint,
    );
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();

    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + 2.2, center.dy - 2.2);
    path.lineTo(center.dx + radius, center.dy);
    path.lineTo(center.dx + 2.2, center.dy + 2.2);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - 2.2, center.dy + 2.2);
    path.lineTo(center.dx - radius, center.dy);
    path.lineTo(center.dx - 2.2, center.dy - 2.2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OrganizationIllustration extends StatelessWidget {
  const _OrganizationIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 12,
            top: 4,
            child: Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Color(0xFF9BD36A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),

          Positioned(
            bottom: 22,
            left: 10,
            right: 10,
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          Container(
            width: 250,
            height: 170,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_rounded,
                  color: Colors.white,
                  size: 58,
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSmallBlock(),
                    const SizedBox(width: 12),
                    _buildSmallBlock(),
                    const SizedBox(width: 12),
                    _buildSmallBlock(),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  width: 82,
                  height: 13,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 6,
            top: 72,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBlock() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }
}
