import 'package:flutter/material.dart';

class CTOnboardingProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CTOnboardingProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;
    final percent = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'STEP $currentStep OF $totalSteps',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: Color(0xFF6C4CF5),
              ),
            ),

            const Spacer(),

            Text(
              '$percent% Complete',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8B8B9A),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: const Color(0xFFE8E7FB),
            valueColor: const AlwaysStoppedAnimation(Color(0xFF6C4CF5)),
          ),
        ),
      ],
    );
  }
}
