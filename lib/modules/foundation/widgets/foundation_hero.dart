import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_overview.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/widgets/dashboard/ct_workspace_overview.dart';

class FoundationHero extends StatelessWidget {
  final CTJourneyController journeyController;

  const FoundationHero({super.key, required this.journeyController});

  @override
  Widget build(BuildContext context) {
    return CTWorkspaceOverview(
      config: foundationOverview(context, journeyController),
    );
  }
}
