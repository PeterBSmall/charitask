import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_overview.dart';
import 'package:charitask/shared/widgets/dashboard/ct_workspace_overview.dart';

class FoundationHero extends StatelessWidget {
  final String firstName;

  const FoundationHero({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return CTWorkspaceOverview(config: foundationOverview(context, firstName));
  }
}
