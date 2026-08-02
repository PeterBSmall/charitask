import 'package:flutter/material.dart';

import 'ct_journey_constants.dart';

class CTJourneyProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CTJourneyProgress({
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
                color: CTJourneyColors.purple,
              ),
            ),

            const Spacer(),

            Text(
              '$percent% Complete',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: CTJourneyColors.subtitle,
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
            valueColor: const AlwaysStoppedAnimation<Color>(
              CTJourneyColors.purple,
            ),
          ),
        ),
      ],
    );
  }
}
