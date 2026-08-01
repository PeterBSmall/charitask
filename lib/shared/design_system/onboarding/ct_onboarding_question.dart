import 'package:flutter/material.dart';

import 'ct_onboarding_constants.dart';

class CTOnboardingQuestion extends StatelessWidget {
  final String title;
  final String question;
  final String subtitle;

  const CTOnboardingQuestion({
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
            color: CTOnboardingColors.text,
            height: 1.05,
          ),
        ),

        const SizedBox(height: CTOnboardingSpacing.badgeSpacing),

        Text(
          question,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: CTOnboardingColors.text,
          ),
        ),

        const SizedBox(height: CTOnboardingSpacing.questionSpacing),

        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 17,
            height: 1.6,
            color: CTOnboardingColors.subtitle,
          ),
        ),
      ],
    );
  }
}
