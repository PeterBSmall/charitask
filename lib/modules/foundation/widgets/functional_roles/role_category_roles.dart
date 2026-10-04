import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/functional_role.dart';

class RoleCategoryRoles extends StatelessWidget {
  final List<FunctionalRole> roles;

  const RoleCategoryRoles({super.key, required this.roles});

  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _purple = Color(0xFF5B3FD3);

  @override
  Widget build(BuildContext context) {
    if (roles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Text(
            'No functional roles are assigned to this category.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: _muted),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Functional Roles',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _text,
          ),
        ),
        const SizedBox(height: 12),
        ...roles.map(
          (role) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _RoleRow(role: role),
          ),
        ),
      ],
    );
  }
}

class _RoleRow extends StatelessWidget {
  final FunctionalRole role;

  const _RoleRow({required this.role});

  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _purple = Color(0xFF5B3FD3);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EBFF),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.badge_outlined, size: 19, color: _purple),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),
                if (role.description?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    role.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: _muted,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  '${role.assignmentCount} assigned',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 18, color: _muted),
        ],
      ),
    );
  }
}
