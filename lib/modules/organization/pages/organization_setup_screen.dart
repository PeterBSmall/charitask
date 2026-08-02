import 'package:flutter/material.dart';

import 'package:charitask/modules/organization/pages/widgets/ct_organization_location_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_name_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_type_step.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class OrganizationSetupScreen extends StatelessWidget {
  const OrganizationSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CTJourneyController(
      photo: const AssetImage('assets/images/onboarding/welcome_people.jpg'),

      steps: [
        (journeyController, next, back) => CTOrganizationNameStep(
          journeyController: journeyController,
          onContinue: next,
        ),

        (journeyController, next, back) => CTOrganizationTypeStep(
          journeyController: journeyController,
          onContinue: next,
          onBack: back,
        ),

        (journeyController, next, back) => CTOrganizationLocationStep(
          journeyController: journeyController,
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
