import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_info_card.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_textfield.dart';

class CTOrganizationNameStep extends StatefulWidget {
  final VoidCallback onContinue;

  const CTOrganizationNameStep({super.key, required this.onContinue});

  @override
  State<CTOrganizationNameStep> createState() => _CTOrganizationNameStepState();
}

class _CTOrganizationNameStepState extends State<CTOrganizationNameStep> {
  final TextEditingController _organizationController = TextEditingController();

  @override
  void dispose() {
    _organizationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 2, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        CTJourneyHeader(
          title: 'Hello Peter.',
          question: "What's the name of your organization?",
          subtitle:
              'This will become the home for your people, locations, volunteers, and mission.',
          icon: Icons.business_outlined,
        ),

        const SizedBox(height: CTJourneySpacing.headerToField),

        CTJourneyTextField(
          controller: _organizationController,
          hintText: 'Enter organization name',
          prefixIcon: Icons.business_outlined,
        ),

        const SizedBox(height: 24),

        const CTJourneyInfoCard(
          icon: Icons.info_outline_rounded,
          title: 'Your organization can always evolve.',
          message:
              'Choose the name people know you by today. You can always update it later in Organization Settings.',
        ),

        const Spacer(),

        CTJourneyButton(text: 'Continue', onPressed: widget.onContinue),
      ],
    );
  }
}
