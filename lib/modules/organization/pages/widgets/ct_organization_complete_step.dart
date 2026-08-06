import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';

class CTOrganizationCompleteStep extends StatelessWidget {
  final VoidCallback onEnterWorkspace;
  final VoidCallback onBack;

  const CTOrganizationCompleteStep({
    super.key,
    required this.onEnterWorkspace,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 7, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        const CTJourneyHeader(
          title: "You're all set!",
          question: "Welcome to ChariTask",
          subtitle: "Your workspace has been personalized and is ready to go.",
          icon: Icons.celebration_outlined,
        ),

        const SizedBox(height: 32),

        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE5D9FF)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _JourneyCheck("Organization created"),
                SizedBox(height: 18),
                _JourneyCheck("Workspace personalized"),
                SizedBox(height: 18),
                _JourneyCheck("Ready to invite your team"),
                Spacer(),
                Text(
                  "Organizations create possibility.",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Now let's build something meaningful together.",
                  style: TextStyle(fontSize: 16),
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
                onPressed: onBack,
                child: const Text("Back"),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: CTJourneyButton(
                text: "Enter Workspace",
                onPressed: onEnterWorkspace,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _JourneyCheck extends StatelessWidget {
  final String text;

  const _JourneyCheck(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF6C4CF1)),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
