import 'package:flutter/material.dart';

import 'package:charitask/modules/organization/pages/widgets/organization_location_step.dart';
import 'package:charitask/modules/organization/pages/widgets/organization_name_step.dart';
import 'package:charitask/modules/organization/pages/widgets/organization_type_step.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class OrganizationSetupScreen extends StatelessWidget {
  const OrganizationSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CTJourneyController(
      photo: const AssetImage('assets/images/onboarding/welcome_people.jpg'),

      steps: [
        (next, back) => CTOrganizationNameStep(onContinue: next),

        (next, back) => CTOrganizationTypeStep(onContinue: next, onBack: back),

        (next, back) => CTOrganizationLocationStep(
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
