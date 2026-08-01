import 'package:flutter/material.dart';

import 'package:charitask/modules/welcome/pages/widgets/welcome_step_1.dart';
import 'package:charitask/shared/design_system/onboarding/ct_onboarding_card.dart';
import 'package:charitask/shared/design_system/onboarding/ct_onboarding_photo.dart';
import 'package:charitask/shared/design_system/onboarding/ct_onboarding_shell.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CTOnboardingShell(
      leftPanel: const CTOnboardingPhoto(
        image: AssetImage('assets/images/onboarding/welcome_people.jpg'),
      ),
      rightPanel: const CTOnboardingCard(child: CTWelcomeStep1()),
    );
  }
}
