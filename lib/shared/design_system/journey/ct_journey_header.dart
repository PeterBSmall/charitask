import 'package:flutter/material.dart';

import 'ct_journey_badge.dart';

class CTJourneyHeader extends StatelessWidget {
  final String title;
  final String question;
  final String subtitle;
  final IconData icon;

  const CTJourneyHeader({
    super.key,
    required this.title,
    required this.question,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
            height: 1.05,
          ),
        ),

        const SizedBox(height: 26),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CTJourneyBadge(icon: icon),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.6,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
