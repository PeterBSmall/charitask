import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace_page.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class FoundationWorkspace extends StatelessWidget {
  const FoundationWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return FoundationWorkspacePage(journeyController: CTJourneyController());
  }
}
