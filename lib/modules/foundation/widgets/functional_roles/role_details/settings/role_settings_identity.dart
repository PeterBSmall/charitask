import 'package:flutter/material.dart';

import '../../../../domain/models/functional_role.dart';
import 'role_settings_widgets.dart';

class RoleSettingsIdentity extends StatelessWidget {
  final FunctionalRole role;

  const RoleSettingsIdentity({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isSystemRole = role.isImported;

    return RoleSettingsCard(
      title: 'Role Identity',
      subtitle: 'How this functional role is managed by the system.',
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSystemRole
                  ? const Color(0xFFEDE9FE)
                  : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isSystemRole
                  ? Icons.admin_panel_settings_outlined
                  : Icons.badge_outlined,
              color: isSystemRole
                  ? const Color(0xFF6D28D9)
                  : const Color(0xFF0369A1),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isSystemRole
                      ? 'This is a system-provided role.'
                      : 'This is a custom organization role.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          RoleTypeBadge(
            label: isSystemRole ? 'System Role' : 'Custom Role',
            systemRole: isSystemRole,
          ),
        ],
      ),
    );
  }
}
