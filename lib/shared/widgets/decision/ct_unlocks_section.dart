import 'package:flutter/material.dart';

import 'package:charitask/shared/decision/decision_result.dart';

class CTUnlocksSection extends StatelessWidget {
  final DecisionResult guidance;

  const CTUnlocksSection({super.key, required this.guidance});

  @override
  Widget build(BuildContext context) {
    if (guidance.benefits.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✨ What This Unlocks',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: guidance.benefits.map((benefit) {
            return Chip(
              avatar: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 18,
              ),
              label: Text(benefit),
            );
          }).toList(),
        ),
      ],
    );
  }
}
