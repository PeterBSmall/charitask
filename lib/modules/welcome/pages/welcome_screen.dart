import 'package:flutter/material.dart';

import 'package:charitask/modules/welcome/pages/widgets/ct_welcome_step_1.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_engine.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CTJourneyController();

    return CTJourneyEngine(
      controller: controller,

      photo: const AssetImage('assets/images/onboarding/welcome_people.jpg'),

      steps: [
        (journeyController, next, back) => CTWelcomeStep1(
          journeyController: journeyController,
          onContinue: next,
        ),
      ],
    );
  }
}
