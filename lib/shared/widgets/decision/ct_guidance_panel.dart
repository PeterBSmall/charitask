import 'package:flutter/material.dart';

import 'package:charitask/shared/decision/decision_result.dart';

class CTGuidancePanel extends StatelessWidget {
  final DecisionResult guidance;

  const CTGuidancePanel({super.key, required this.guidance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),

        leading: const CircleAvatar(child: Icon(Icons.psychology)),

        title: Text(
          guidance.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(guidance.recommendation),

              const SizedBox(height: 12),

              Text(
                guidance.explanation,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
