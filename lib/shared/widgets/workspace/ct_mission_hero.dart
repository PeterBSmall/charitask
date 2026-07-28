import 'package:flutter/material.dart';

class CTMissionHero extends StatelessWidget {
  final String suite;
  final String headline;
  final String description;
  final String nextStep;
  final double progress;
  final IconData icon;
  final Color color;

  const CTMissionHero({
    super.key,
    required this.suite,
    required this.headline,
    required this.description,
    required this.nextStep,
    required this.progress,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color),

                    const SizedBox(width: 10),

                    Text(
                      suite.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  headline,
                  style: const TextStyle(
                    fontSize: 34,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.6,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 48),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Next Step",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  nextStep,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 20),

                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    color: color,
                    backgroundColor: Colors.grey.shade200,
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
