import 'package:flutter/material.dart';

class LocationStatusBadge extends StatelessWidget {
  final bool isActive;

  const LocationStatusBadge({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isActive
        ? const Color(0xFFE8F8EE)
        : const Color(0xFFF1F5F9);

    final foregroundColor = isActive
        ? const Color(0xFF15803D)
        : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: foregroundColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
