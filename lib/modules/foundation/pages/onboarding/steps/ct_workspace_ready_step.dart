import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';

class CTWorkspaceReadyStep extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const CTWorkspaceReadyStep({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<CTWorkspaceReadyStep> createState() => _CTWorkspaceReadyStepState();
}

class _CTWorkspaceReadyStepState extends State<CTWorkspaceReadyStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _twinkle(double value, double offset) {
    final progress = (value + offset) % 1.0;

    // Most of the time the sparkle stays visible.
    // It briefly brightens, then softly fades back.
    if (progress < 0.15) {
      return 0.65 + (progress / 0.15) * 0.35;
    }

    if (progress < 0.30) {
      return 1.0 - ((progress - 0.15) / 0.15) * 0.35;
    }

    return 0.65;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 7, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        const CTJourneyHeader(
          title: 'Your Workspace Is Ready.',
          question: '',
          subtitle:
              'ChariTask has personalized your workspace around the way your organization serves its community.',
          icon: Icons.check_circle_outline,
        ),

        const SizedBox(height: 32),

        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE5D9FF)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return SizedBox(
                      width: 72,
                      height: 64,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Main sparkle
                          Positioned(
                            left: 19,
                            top: 13,
                            child: Opacity(
                              opacity: _twinkle(_controller.value, 0.0),
                              child: const Icon(
                                Icons.star,
                                size: 34,
                                color: Color(0xFF6C4CF1),
                              ),
                            ),
                          ),

                          // Upper-right sparkle
                          Positioned(
                            right: 9,
                            top: 4,
                            child: Opacity(
                              opacity: _twinkle(_controller.value, 0.33),
                              child: const Icon(
                                Icons.star,
                                size: 19,
                                color: Color(0xFF6C4CF1),
                              ),
                            ),
                          ),

                          // Lower-right sparkle
                          Positioned(
                            right: 8,
                            bottom: 5,
                            child: Opacity(
                              opacity: _twinkle(_controller.value, 0.66),
                              child: const Icon(
                                Icons.star,
                                size: 18,
                                color: Color(0xFF6C4CF1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Everything is in place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C4CF1),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Your organization profile is complete, '
                  'and your workspace is ready to grow with your mission.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onBack,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text('Back', style: TextStyle(fontSize: 17)),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: CTJourneyButton(
                text: 'Enter My Workspace',
                onPressed: widget.onContinue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
