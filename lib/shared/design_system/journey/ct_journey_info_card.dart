import 'package:flutter/material.dart';

class CTJourneyInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const CTJourneyInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E2FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF6C4CF5),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.55,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
