import 'package:flutter/material.dart';

import 'ct_journey_constants.dart';

class CTJourneyBadge extends StatelessWidget {
  final IconData icon;

  const CTJourneyBadge({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: CTJourneySizes.badgeSize,
      height: CTJourneySizes.badgeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CTJourneyColors.badgeBackground,
        border: Border.all(color: CTJourneyColors.badgeBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: 30, color: CTJourneyColors.purple),
    );
  }
}
