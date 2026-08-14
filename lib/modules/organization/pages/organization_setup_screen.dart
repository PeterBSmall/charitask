import 'package:flutter/material.dart';

import 'package:charitask/modules/organization/pages/widgets/ct_organization_location_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_name_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_type_step.dart';

import 'package:charitask/shared/data/ct_journey_heroes.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_chapter.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_engine.dart';

import 'package:charitask/modules/foundation/pages/onboarding/steps/ct_workspace_creation_step.dart';

class OrganizationSetupScreen extends StatelessWidget {
  final void Function(CTJourneyController controller)? onComplete;
  final void Function(CTJourneyController controller)? onCompleteProfile;
  final String firstName;

  const OrganizationSetupScreen({
    super.key,
    this.onComplete,
    this.onCompleteProfile,
    required this.firstName,
  });

  @override
  Widget build(BuildContext context) {
    final journeyController = CTJourneyController();

    journeyController.updateFirstName(firstName);

    return CTJourneyEngine(
      controller: journeyController,

      onComplete: () {
        onComplete?.call(journeyController);
      },

      chapters: const [
        CTJourneyChapter(hero: CTJourneyHeroes.organizationSetup),
        CTJourneyChapter(hero: CTJourneyHeroes.organizationSetup),
        CTJourneyChapter(hero: CTJourneyHeroes.organizationType),
        CTJourneyChapter(hero: CTJourneyHeroes.organizationType),
      ],

      steps: [
        (journeyController, next, back) => CTOrganizationNameStep(
          journeyController: journeyController,
          onContinue: next,
          onBack: back,
        ),

        (journeyController, next, back) => CTOrganizationTypeStep(
          journeyController: journeyController,
          onContinue: next,
          onBack: back,
        ),

        (journeyController, next, back) => CTOrganizationLocationStep(
          journeyController: journeyController,
          onContinue: next,
          onBack: back,
        ),

        (journeyController, next, back) => CTWorkspaceCreationStep(
          profile: journeyController.missionProfile,
          onContinue: next,
          onCompleteProfile: () {
            onCompleteProfile?.call(journeyController);
          },
        ),
      ],
    );
  }
}
