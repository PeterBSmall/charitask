import 'package:flutter/material.dart';

import 'package:charitask/modules/organization/pages/widgets/ct_organization_location_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_name_step.dart';
import 'package:charitask/modules/organization/pages/widgets/ct_organization_type_step.dart';

import 'package:charitask/shared/data/ct_journey_heroes.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_chapter.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_engine.dart';

class OrganizationSetupScreen extends StatelessWidget {
  final VoidCallback? onComplete;

  const OrganizationSetupScreen({super.key, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return CTJourneyEngine(
      controller: CTJourneyController(),

      onComplete: onComplete,

      chapters: const [
        CTJourneyChapter(hero: CTJourneyHeroes.organizationSetup),
        CTJourneyChapter(hero: CTJourneyHeroes.organizationSetup),
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
      ],
    );
  }
}
