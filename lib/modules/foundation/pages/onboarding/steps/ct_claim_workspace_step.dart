import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';

class CTClaimWorkspaceStep extends StatelessWidget {
  final CTJourneyController controller;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const CTClaimWorkspaceStep({
    super.key,
    required this.controller,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final organizationName = controller.organization.identity.name.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 8, totalSteps: 9),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        const Text(
          'Your Workspace Is Ready.',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          organizationName.isEmpty
              ? 'ChariTask has personalized your workspace for your organization.'
              : 'ChariTask has personalized your workspace for $organizationName.',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 64,
                  color: Color(0xFF6C4CF1),
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

                Text(
                  organizationName.isEmpty
                      ? 'Your organization, mission, people, and workspace are ready to grow with you.'
                      : '$organizationName has a workspace ready to grow with your mission.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5D9FF)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF6C4CF1)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your organization profile is complete.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
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
                text: 'Claim My Workspace',
                onPressed: onContinue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
