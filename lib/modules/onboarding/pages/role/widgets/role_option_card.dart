import 'package:flutter/material.dart';

import 'package:charitask/domain/identity/organization_role.dart';

class RoleOptionCard extends StatelessWidget {
  final OrganizationRole role;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final bool selected;
  final VoidCallback onTap;

  const RoleOptionCard({
    super.key,
    required this.role,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 126,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF7F4FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? accentColor : const Color(0xFFE2E5EC),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------------------------------------
            // ICON
            // ----------------------------------------------------------
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? accentColor.withValues(alpha: 0.14)
                    : accentColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 25),
            ),

            const SizedBox(width: 12),

            // ----------------------------------------------------------
            // CONTENT
            // ----------------------------------------------------------
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF182238),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF596579),
                      fontSize: 12,
                      height: 1.30,
                    ),
                  ),
                ],
              ),
            ),

            // ----------------------------------------------------------
            // SELECTED CHECKMARK
            // ----------------------------------------------------------
            if (selected) ...[
              const SizedBox(width: 8),

              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
