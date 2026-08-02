import 'package:flutter/material.dart';

import 'ct_journey_constants.dart';

class CTJourneyCard extends StatelessWidget {
  final Widget child;

  const CTJourneyCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CTJourneySizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(padding: CTJourneySpacing.cardPadding, child: child),
    );
  }
}
