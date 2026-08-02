import 'package:flutter/material.dart';

import 'ct_journey_constants.dart';

class CTJourneyQuestion extends StatelessWidget {
  final String title;
  final String question;
  final String subtitle;

  const CTJourneyQuestion({
    super.key,
    required this.title,
    required this.question,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: CTJourneyColors.text,
            height: 1.05,
          ),
        ),

        const SizedBox(height: CTJourneySpacing.badgeSpacing),

        Text(
          question,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: CTJourneyColors.text,
          ),
        ),

        const SizedBox(height: CTJourneySpacing.questionSpacing),

        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 17,
            height: 1.6,
            color: CTJourneyColors.subtitle,
          ),
        ),
      ],
    );
  }
}
