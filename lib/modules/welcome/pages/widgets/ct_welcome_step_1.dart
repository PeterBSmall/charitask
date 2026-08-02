import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_textfield.dart';

class CTWelcomeStep1 extends StatefulWidget {
  final CTJourneyController journeyController;
  final VoidCallback onContinue;

  const CTWelcomeStep1({
    super.key,
    required this.journeyController,
    required this.onContinue,
  });

  @override
  State<CTWelcomeStep1> createState() => _CTWelcomeStep1State();
}

class _CTWelcomeStep1State extends State<CTWelcomeStep1> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.journeyController.firstName,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 1, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        CTJourneyHeader(
          title: 'Welcome to ChariTask',
          question: 'What should we call you?',
          subtitle: "Let's start with something simple.",
          icon: Icons.person_outline_rounded,
        ),

        const SizedBox(height: CTJourneySpacing.headerToField),

        CTJourneyTextField(
          controller: _nameController,
          hintText: 'Enter your first name',
        ),

        const SizedBox(height: CTJourneySpacing.fieldToButton),

        CTJourneyButton(
          text: 'Continue',
          onPressed: () {
            widget.journeyController.updateFirstName(
              _nameController.text.trim(),
            );

            widget.onContinue();
          },
        ),
      ],
    );
  }
}
