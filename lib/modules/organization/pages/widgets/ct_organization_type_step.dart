import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';

class CTOrganizationTypeStep extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const CTOrganizationTypeStep({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<CTOrganizationTypeStep> createState() => _CTOrganizationTypeStepState();
}

class _CTOrganizationTypeStepState extends State<CTOrganizationTypeStep> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 3, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        CTJourneyHeader(
          title: 'Hello Peter.',
          question: 'What best describes your organization?',
          subtitle: 'This helps ChariTask tailor your experience.',
          icon: Icons.apartment_outlined,
        ),

        const SizedBox(height: 28),

        // We'll build the cards next.
        const Spacer(),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onBack,
                child: const Text('Back'),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: CTJourneyButton(
                text: 'Continue',
                onPressed: widget.onContinue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
