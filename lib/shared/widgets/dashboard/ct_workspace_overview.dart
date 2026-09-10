import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/buttons/ct_button.dart';
import 'package:charitask/shared/models/ct_workspace_overview_config.dart';
import 'dart:ui';

class CTWorkspaceOverview extends StatelessWidget {
  final CTWorkspaceOverviewConfig config;

  const CTWorkspaceOverview({super.key, required this.config});

  bool get _isCompleted => config.progress == null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_isCompleted) {
            return _buildCompletedLayout(context, constraints);
          }

          return _buildSetupLayout(context, constraints);
        },
      ),
    );
  }

  // ===========================================================================
  // COMPLETED WORKSPACE
  // ===========================================================================

  Widget _buildCompletedLayout(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    final isNarrow = constraints.maxWidth < 850;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        constraints: const BoxConstraints(minHeight: 340),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF100D24), Color(0xFF1C1647), Color(0xFF3B1F8A)],
          ),
        ),
        child: Stack(
          children: [
            // Top glow
            Positioned(
              top: -220,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF8B5CF6).withValues(alpha: .45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom-right glow
            Positioned(
              right: -100,
              bottom: -100,
              child: Container(
                width: 550,
                height: 550,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF8B5CF6).withValues(alpha: .50),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Ribbon 1
            Positioned(
              bottom: -80,
              right: -120,
              child: Transform.rotate(
                angle: -.35,
                child: Container(
                  width: 700,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF7C3AED).withValues(alpha: .35),
                        const Color(0xFFA855F7).withValues(alpha: .75),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Ribbon 2
            Positioned(
              bottom: -20,
              right: -180,
              child: Transform.rotate(
                angle: -.35,
                child: Container(
                  width: 650,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF6D28D9).withValues(alpha: .25),
                        const Color(0xFF8B5CF6).withValues(alpha: .55),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(40, 34, 40, 34),
              child: isNarrow
                  ? Column(
                      children: [
                        _buildCompletedText(context),
                        const SizedBox(height: 24),
                        _buildCompletedIllustration(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 650,
                              child: _buildCompletedText(context),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(flex: 4, child: _buildCompletedIllustration()),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedText(BuildContext context) {
    final titleSize = MediaQuery.of(context).size.width > 1200 ? 44.0 : 36.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFA7E163),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'ORGANIZATION WORKSPACE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        Text(
          config.welcomeMessage,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: titleSize,
            height: 1.1,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          config.organizationName,
          style: TextStyle(
            fontSize: 18,
            height: 1.5,
            color: Colors.white.withValues(alpha: .75),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedIllustration() {
    return SizedBox(
      height: 260,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 340,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: .28),
                  Colors.white.withValues(alpha: .18),
                ],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: .30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .28),
                  blurRadius: 50,
                  offset: const Offset(0, 24),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: .12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_balance_rounded,
                        size: 58,
                        color: Colors.white,
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _avatarDot(),
                          const SizedBox(width: 12),
                          _avatarDot(),
                          const SizedBox(width: 16),
                          _line(90),
                        ],
                      ),

                      const SizedBox(height: 14),

                      _line(120),

                      const SizedBox(height: 12),

                      _line(90),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: -30,
            right: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFA7D56A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 54,
                color: Colors.white,
              ),
            ),
          ),

          Positioned(
            left: -55,
            top: 85,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: .12),
                border: Border.all(color: Colors.white.withValues(alpha: .20)),
              ),
              child: const Icon(Icons.trending_up_rounded, color: Colors.white),
            ),
          ),

          Positioned(
            right: 10,
            top: 50,
            child: Icon(
              Icons.auto_awesome,
              size: 34,
              color: Colors.white.withValues(alpha: .8),
            ),
          ),

          Positioned(
            left: 5,
            top: 40,
            child: Icon(
              Icons.auto_awesome,
              size: 22,
              color: Colors.white.withValues(alpha: .7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _illustrationWindow() {
    return Container(
      width: 24,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _illustrationBadge({required IconData icon}) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Icon(icon, size: 21, color: Colors.white),
    );
  }

  Widget _heroFloatingBadge({required IconData icon}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Icon(icon, size: 23, color: Colors.white),
    );
  }

  // ===========================================================================
  // SETUP STATE
  // ===========================================================================

  Widget _buildSetupLayout(BuildContext context, BoxConstraints constraints) {
    final isNarrow = constraints.maxWidth < 1100;

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSetupText(),
          const SizedBox(height: 24),
          _buildProgressCard(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: 650, child: _buildSetupText()),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(flex: 4, child: _buildProgressCard()),
      ],
    );
  }

  Widget _buildSetupText() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config.greeting,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          config.welcomeMessage,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 26,
            height: 1.05,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          config.organizationName,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 17,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),

        if (config.mission.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            config.mission,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Colors.white70,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressCard() {
    final progress = config.progress!;
    final nextStep = config.nextStep!;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'SETUP PROGRESS',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            nextStep,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: CTButton(
                  label: config.primaryButtonLabel,
                  onPressed: config.onPrimaryPressed,
                ),
              ),
              if (config.secondaryButtonLabel != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: CTButton(
                    label: config.secondaryButtonLabel!,
                    onPressed: config.onSecondaryPressed,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// HERO BACKGROUND PAINTER
// ===========================================================================

class _HeroSweepPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 110
      ..shader =
          const LinearGradient(
            colors: [Color(0x006D28D9), Color(0x557C3AED), Color(0x996D28D9)],
          ).createShader(
            Rect.fromLTWH(
              size.width * 0.35,
              -size.height,
              size.width,
              size.height * 2,
            ),
          );

    final path = Path()
      ..moveTo(size.width * 0.52, -80)
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.10,
        size.width * 0.72,
        size.height * 0.78,
        size.width * 1.08,
        size.height * 1.05,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

Widget _avatarDot() {
  return Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withValues(alpha: .18),
    ),
    child: const Icon(Icons.person, size: 16, color: Colors.white),
  );
}

Widget _line(double width) {
  return Container(
    width: width,
    height: 10,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: Colors.white.withValues(alpha: .22),
    ),
  );
}
