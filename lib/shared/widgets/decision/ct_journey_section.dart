import 'package:flutter/material.dart';

import 'package:charitask/shared/decision/decision_result.dart';

class CTJourneySection extends StatelessWidget {
  final DecisionResult guidance;

  const CTJourneySection({super.key, required this.guidance});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🌱 Your Journey',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: guidance.progress,
            minHeight: 10,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          guidance.progressLabel,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
