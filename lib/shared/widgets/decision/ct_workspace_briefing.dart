import 'package:flutter/material.dart';

import 'package:charitask/shared/decision/decision_result.dart';
import 'package:charitask/shared/widgets/decision/ct_focus_card.dart';
import 'package:charitask/shared/widgets/decision/ct_journey_section.dart';
import 'package:charitask/shared/widgets/decision/ct_unlocks_section.dart';

class CTDecisionSurface extends StatelessWidget {
  final DecisionResult guidance;

  const CTDecisionSurface({super.key, required this.guidance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
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

            const SizedBox(height: 24),

            CTFocusCard(guidance: guidance),

            const SizedBox(height: 28),

            CTUnlocksSection(guidance: guidance),

            const SizedBox(height: 28),

            CTJourneySection(guidance: guidance),
          ],
        ),
      ),
    );
  }
}
