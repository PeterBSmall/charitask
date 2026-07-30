import 'package:flutter/material.dart';

import 'package:charitask/shared/decision/decision_engine.dart';
import 'package:charitask/shared/decision/workspace_context.dart';
import 'package:charitask/shared/widgets/dashboard/index.dart';
import 'package:charitask/shared/widgets/layout/ct_page.dart';
import 'package:charitask/shared/widgets/decision/ct_workspace_briefing.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace_page.dart';

class FoundationWorkspace extends StatelessWidget {
  const FoundationWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = const DecisionEngine();

    final guidance = engine.evaluate(
      const WorkspaceContext(
        workspaceId: 'foundation',
        personId: 'peter',
        organizationId: 'habitat',
      ),
    );

    return CTPage(
      child: Column(
        children: [
          CTDecisionSurface(guidance: guidance),

          const Expanded(child: CTSuiteDashboard(config: foundationDashboard)),
        ],
      ),
    );
  }
}
