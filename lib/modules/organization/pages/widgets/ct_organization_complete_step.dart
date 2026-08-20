import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/onboarding/steps/ct_workspace_creation_step.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class CTOrganizationCompleteStep extends StatelessWidget {
  final VoidCallback onEnterWorkspace;
  final VoidCallback onBack;
  final CTJourneyController controller;

  const CTOrganizationCompleteStep({
    super.key,
    required this.controller,
    required this.onEnterWorkspace,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return CTWorkspaceCreationStep(
      profile: controller.missionProfile,
      onContinue: onEnterWorkspace,
      onCompleteProfile: () {
        // Profile completion will be connected here.
      },
    );
  }
}
