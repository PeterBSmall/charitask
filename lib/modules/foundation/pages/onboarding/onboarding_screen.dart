import 'package:flutter/material.dart';

import 'package:charitask/modules/welcome/pages/widgets/ct_welcome_step_1.dart';

import 'package:charitask/modules/organization/pages/widgets/ct_organization_name_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_type_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_location_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_size_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_mission_step.dart';

import 'package:charitask/modules/foundation/pages/onboarding/steps/ct_workspace_creation_step.dart';
import 'package:charitask/modules/foundation/pages/onboarding/steps/ct_claim_workspace_step.dart';
import 'package:charitask/modules/foundation/pages/onboarding/steps/ct_enter_workspace_step.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace.dart';

import 'package:charitask/shared/data/ct_journey_heroes.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_chapter.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_engine.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CTJourneyEngine(
      controller: CTJourneyController(),

      chapters: const [
        CTJourneyChapter(hero: CTJourneyHeroes.welcome),

        CTJourneyChapter(hero: CTJourneyHeroes.organizationSetup),

        CTJourneyChapter(hero: CTJourneyHeroes.organizationType),

        CTJourneyChapter(hero: CTJourneyHeroes.organizationLocation),

        CTJourneyChapter(hero: CTJourneyHeroes.organizationLocation),

        CTJourneyChapter(hero: CTJourneyHeroes.organizationLocation),

        CTJourneyChapter(hero: CTJourneyHeroes.organizationLocation),

        CTJourneyChapter(hero: CTJourneyHeroes.organizationLocation),

        CTJourneyChapter(hero: CTJourneyHeroes.organizationLocation),
      ],

      steps: [
        // Step 1 - Welcome
        (controller, next, back) =>
            CTWelcomeStep1(journeyController: controller, onContinue: next),

        // Step 2 - Organization Name
        (controller, next, back) => CTOrganizationNameStep(
          journeyController: controller,
          onContinue: next,
          onBack: back,
        ),

        // Step 3 - Organization Type
        (controller, next, back) => CTOrganizationTypeStep(
          journeyController: controller,
          onContinue: next,
          onBack: back,
        ),

        // Step 4 - Organization Location
        (controller, next, back) => CTOrganizationLocationStep(
          journeyController: controller,
          onContinue: next,
          onBack: back,
        ),

        // Step 5 - Organization Size
        (controller, next, back) => CTOrganizationSizeStep(
          journeyController: controller,
          onContinue: next,
          onBack: back,
        ),

        // Step 6 - Organization Mission
        (controller, next, back) => CTOrganizationMissionStep(
          journeyController: controller,
          onContinue: next,
          onBack: back,
        ),

        // Step 7 - Creating Workspace
        (controller, next, back) => CTWorkspaceCreationStep(
          profile: controller.missionProfile,
          onContinue: next,
        ),

        // Step 8 - Claim Workspace
        (controller, next, back) => CTClaimWorkspaceStep(
          controller: controller,
          onContinue: next,
          onBack: back,
        ),

        // Step 9 - Enter Workspace
        (controller, next, back) => CTEnterWorkspaceStep(
          organizationName: controller.organization.identity.name,
          onEnterWorkspace: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const FoundationWorkspace()),
            );
          },
          onBack: back,
        ),
      ],
    );
  }
}
