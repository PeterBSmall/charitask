import 'package:charitask/shared/decision/decision_result.dart';
import 'package:charitask/shared/decision/workspace_context.dart';

import 'evaluators/foundation_evaluator.dart';

class DecisionEngine {
  const DecisionEngine();

  DecisionResult evaluate(WorkspaceContext context) {
    switch (context.workspaceId) {
      case 'foundation':
        return const FoundationEvaluator().evaluate(context);

      default:
        return const DecisionResult(
          title: 'Welcome',
          recommendation: 'Select a workspace.',
          explanation: 'No evaluator has been registered for this workspace.',
        );
    }
  }
}
