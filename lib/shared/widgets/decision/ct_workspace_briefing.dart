import 'package:flutter/material.dart';

import 'package:charitask/shared/decision/decision_result.dart';
import 'package:charitask/shared/widgets/decision/ct_focus_card.dart';
import 'package:charitask/shared/widgets/decision/ct_journey_section.dart';
import 'package:charitask/shared/widgets/decision/ct_unlocks_section.dart';
import 'package:charitask/shared/widgets/decision/ct_workspace_header.dart';

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
            CTWorkspaceHeader(guidance: guidance),

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
