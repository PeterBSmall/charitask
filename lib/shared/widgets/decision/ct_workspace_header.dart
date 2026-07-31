import 'package:flutter/material.dart';

import 'package:charitask/shared/decision/decision_result.dart';

class CTWorkspaceHeader extends StatelessWidget {
  final DecisionResult guidance;

  const CTWorkspaceHeader({super.key, required this.guidance});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          guidance.greeting,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 6),

        Text(
          "Today's Focus",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        Text(
          guidance.summary,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
