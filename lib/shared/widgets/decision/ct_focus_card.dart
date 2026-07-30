import 'package:flutter/material.dart';

import 'package:charitask/shared/decision/decision_result.dart';

class CTFocusCard extends StatelessWidget {
  final DecisionResult guidance;

  const CTFocusCard({super.key, required this.guidance});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: guidance.priority == DecisionPriority.high
                    ? Colors.red.shade50
                    : guidance.priority == DecisionPriority.normal
                    ? Colors.orange.shade50
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: guidance.priority == DecisionPriority.high
                      ? Colors.red.shade300
                      : guidance.priority == DecisionPriority.normal
                      ? Colors.orange.shade300
                      : Colors.green.shade300,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    guidance.priority == DecisionPriority.high
                        ? Icons.priority_high
                        : guidance.priority == DecisionPriority.normal
                        ? Icons.info_outline
                        : Icons.check_circle,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    guidance.priority.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              guidance.recommendation,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              guidance.explanation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.grey),

                const SizedBox(width: 8),

                Text(
                  guidance.estimatedTime,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Create Location'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
