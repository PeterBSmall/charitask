import 'package:flutter/material.dart';

import 'ct_journey_button.dart';
import 'ct_journey_constants.dart';
import 'ct_journey_header.dart';
import 'ct_journey_progress.dart';

class CTJourneyPage extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  final String title;
  final String question;
  final String subtitle;
  final IconData icon;

  final Widget body;

  final String buttonText;
  final VoidCallback onContinue;

  final Widget? footer;

  const CTJourneyPage({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.question,
    required this.subtitle,
    required this.icon,
    required this.body,
    required this.buttonText,
    required this.onContinue,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CTJourneyProgress(currentStep: currentStep, totalSteps: totalSteps),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        CTJourneyHeader(
          title: title,
          question: question,
          subtitle: subtitle,
          icon: icon,
        ),

        const SizedBox(height: CTJourneySpacing.headerToField),

        body,

        const Spacer(),

        if (footer != null) ...[footer!, const SizedBox(height: 20)],

        CTJourneyButton(text: buttonText, onPressed: onContinue),
      ],
    );
  }
}
