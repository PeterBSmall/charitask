import 'package:flutter/material.dart';

import 'package:charitask/modules/welcome/pages/widgets/welcome_step_1.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_card.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_photo.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_shell.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CTJourneyShell(
      leftPanel: const CTJourneyPhoto(
        image: AssetImage('assets/images/onboarding/welcome_people.jpg'),
      ),
      rightPanel: const CTJourneyCard(child: CTWelcomeStep1()),
    );
  }
}
