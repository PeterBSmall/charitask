import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace.dart';
import 'package:charitask/modules/foundation/widgets/mission_control_shell.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class FoundationAppPage extends StatelessWidget {
  final CTJourneyController journeyController;

  const FoundationAppPage({super.key, required this.journeyController});

  @override
  Widget build(BuildContext context) {
    return MissionControlShell(
      child: FoundationWorkspace(journeyController: journeyController),
    );
  }
}
