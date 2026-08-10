import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';

class CTWorkspaceReadyStep extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const CTWorkspaceReadyStep({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 8, totalSteps: 9),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        const CTJourneyHeader(
          title: 'Your Workspace Is Ready',
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
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome, size: 56, color: Color(0xFF6C4CF1)),

                SizedBox(height: 24),

                Text(
                  'Everything is ready.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C4CF1),
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  'Your organization, mission, people, and workspace '
                  'are ready to come together.',
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
                onPressed: onBack,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text('Back', style: TextStyle(fontSize: 17)),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: CTJourneyButton(text: 'Continue', onPressed: onContinue),
            ),
          ],
        ),
      ],
    );
  }
}
