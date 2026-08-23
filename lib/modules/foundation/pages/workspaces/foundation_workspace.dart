import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace_page.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class FoundationWorkspace extends StatelessWidget {
  final CTJourneyController journeyController;

  const FoundationWorkspace({super.key, required this.journeyController});

  @override
  Widget build(BuildContext context) {
    return FoundationWorkspacePage(journeyController: journeyController);
  }
}
