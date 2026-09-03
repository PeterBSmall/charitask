import 'package:flutter/material.dart';

import 'package:charitask/modules/organization/pages/widgets/ct_organization_location_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_name_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_type_step.dart';

import 'package:charitask/shared/data/ct_journey_heroes.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_chapter.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_engine.dart';

import 'package:charitask/modules/foundation/pages/onboarding/steps/ct_workspace_creation_step.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace.dart';
import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';

class OrganizationSetupScreen extends StatelessWidget {
  final void Function(CTJourneyController controller)? onComplete;
  final void Function(CTJourneyController controller)? onCompleteProfile;
  final String firstName;
  final OnboardingController onboardingController;

  const OrganizationSetupScreen({
    super.key,
    this.onComplete,
    this.onCompleteProfile,
    required this.firstName,
    required this.onboardingController,
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
          journeyController: journeyController,
          onboardingController: onboardingController,

          // Go directly to the Foundation Workspace.
          onContinue: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) =>
                    FoundationWorkspace(journeyController: journeyController),
              ),
            );
          },

          // Complete Personal Profile remains a separate path.
          onCompleteProfile: () {
            onCompleteProfile?.call(journeyController);
          },
        ),
      ],
    );
  }
}
