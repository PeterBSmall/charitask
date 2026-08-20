import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/organization/organization_workspace.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class AppRouter {
  AppRouter._();

  static Future<void> goToOrganization(
    BuildContext context,
    CTJourneyController journeyController,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            OrganizationWorkspace(journeyController: journeyController),
      ),
    );
  }
}
