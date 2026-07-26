import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace_page.dart';
import 'package:charitask/shared/widgets/dashboard/index.dart';
import 'package:charitask/shared/widgets/layout/ct_page.dart';

class FoundationWorkspace extends StatelessWidget {
  const FoundationWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return const CTPage(child: CTSuiteDashboard(config: foundationDashboard));
  }
}
