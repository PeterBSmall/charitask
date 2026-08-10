import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';

class CTEnterWorkspaceStep extends StatelessWidget {
  final String organizationName;
  final VoidCallback onEnterWorkspace;
  final VoidCallback onBack;

  const CTEnterWorkspaceStep({
    super.key,
    required this.organizationName,
    required this.onEnterWorkspace,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 9, totalSteps: 9),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        const Text(
          'Welcome to ChariTask.',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          organizationName.trim().isEmpty
              ? 'Your workspace is ready.'
              : 'Your workspace for $organizationName is ready.',
          style: const TextStyle(
            fontSize: 18,
            height: 1.5,
            color: Colors.black54,
          ),
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
                Icon(Icons.auto_awesome, size: 64, color: Color(0xFF6C4CF1)),

                SizedBox(height: 24),

                Text(
                  'Let’s get started.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C4CF1),
                  ),
                ),

                SizedBox(height: 16),

                Text(
                  'Everything you need to begin building your '
                  'mission-driven workspace is waiting for you.',
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
              child: CTJourneyButton(
                text: 'Enter My Workspace',
                onPressed: onEnterWorkspace,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
