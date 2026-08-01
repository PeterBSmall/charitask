import 'package:flutter/material.dart';

class CTOnboardingBadge extends StatelessWidget {
  final IconData icon;

  const CTOnboardingBadge({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF5F1FF),
        border: Border.all(color: const Color(0xFFE5DDFF), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: 30, color: const Color(0xFF6C4CF5)),
    );
  }
}
