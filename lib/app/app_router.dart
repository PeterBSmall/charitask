import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/organization/organization_workspace.dart';

class AppRouter {
  AppRouter._();

  static Future<void> goToOrganization(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const OrganizationWorkspace()));
  }
}
