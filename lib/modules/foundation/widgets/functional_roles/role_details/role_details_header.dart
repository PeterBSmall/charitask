import 'package:flutter/material.dart';

import '../../../domain/models/functional_role.dart';
import '../../../domain/models/functional_role_category.dart';

class RoleDetailsHeader extends StatelessWidget {
  final FunctionalRoleCategory category;
  final FunctionalRole role;

  const RoleDetailsHeader({
    super.key,
    required this.category,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _Badge(
                label: role.isImported ? 'System Role' : 'Custom Role',
                color: role.isImported
                    ? const Color(0xFF5B3FD3)
                    : const Color(0xFF64748B),
                background: role.isImported
                    ? const Color(0xFFF0EBFF)
                    : const Color(0xFFF1F5F9),
              ),
              _Badge(
                label: category.name,
                color: const Color(0xFF64748B),
                background: Colors.white,
              ),
              _Badge(
                label: role.isActive ? 'Active' : 'Inactive',
                color: role.isActive
                    ? const Color(0xFF15803D)
                    : const Color(0xFF64748B),
                background: role.isActive
                    ? const Color(0xFFE8F7EE)
                    : const Color(0xFFF1F5F9),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            role.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          if (role.description?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              role.description!,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: Color(0xFF64748B),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Metric(
                value: '${role.assignmentCount}',
                label: 'Assigned People',
                icon: Icons.people_outline,
              ),
              _Metric(
                value: role.isImported ? 'System' : 'Custom',
                label: 'Role Type',
                icon: Icons.badge_outlined,
              ),
              _Metric(
                value: role.isActive ? 'Active' : 'Inactive',
                label: 'Status',
                icon: Icons.circle_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;

  const _Badge({
    required this.label,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _Metric({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: const Color(0xFF64748B)),
          const SizedBox(width: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
