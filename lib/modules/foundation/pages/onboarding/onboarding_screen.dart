import 'package:flutter/material.dart';

import 'package:charitask/modules/welcome/pages/widgets/ct_welcome_step_1.dart';

import 'package:charitask/modules/organization/pages/widgets/ct_organization_name_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_type_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_location_step.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_engine.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_chapter.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CTJourneyEngine(
      controller: CTJourneyController(),
      chapters: const [
        // Chapter 1 - Welcome
        CTJourneyChapter(
          image: AssetImage('assets/images/onboarding/welcome_people.jpg'),
          title: 'Welcome to ChariTask',
          subtitle:
              'Technology built for organizations that make a difference.',
        ),

        // Chapter 2 - Organization Name
        CTJourneyChapter(
          image: AssetImage('assets/images/onboarding/organization_setup.jpg'),
          title: 'Organizations create possibility.',
          subtitle: 'Every great mission begins with a strong foundation.',
        ),

        // Chapter 3 - Organization Type
        CTJourneyChapter(
          image: AssetImage('assets/images/onboarding/organization_type.png'),
          title: 'Every mission is unique.',
          subtitle:
              'The way your organization serves its community helps ChariTask personalize your workspace from day one.',
        ),

        // Chapter 4 - Organization Location
        CTJourneyChapter(
          image: AssetImage('assets/images/onboarding/welcome_people.jpg'),
          title: 'Organizations create possibility.',
          subtitle: 'Every great mission begins with a strong foundation.',
        ),
      ],
      steps: [
        // Chapter 1 - Welcome
        (controller, next, back) =>
            CTWelcomeStep1(journeyController: controller, onContinue: next),

        // Chapter 2 - Organization Name
        (controller, next, back) => CTOrganizationNameStep(
          journeyController: controller,
          onContinue: next,
          onBack: back,
        ),

        // Chapter 3 - Organization Type
        (controller, next, back) => CTOrganizationTypeStep(
          journeyController: controller,
          onContinue: next,
          onBack: back,
        ),

        // Chapter 4 - Organization Location
        (controller, next, back) => CTOrganizationLocationStep(
          journeyController: controller,
          onContinue: () {
            debugPrint('Organization setup complete!');
            // TODO: Launch People Journey
          },
          onBack: back,
        ),
      ],
    );
  }
}
