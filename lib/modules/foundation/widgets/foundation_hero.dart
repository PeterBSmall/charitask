import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_overview.dart';
import 'package:charitask/shared/widgets/dashboard/ct_workspace_overview.dart';

class FoundationHero extends StatelessWidget {
  const FoundationHero({super.key});

  @override
  Widget build(BuildContext context) {
    return CTWorkspaceOverview(config: foundationOverview);
  }
}
