import 'package:flutter/material.dart';

import '../../../../domain/models/functional_role.dart';
import 'role_settings_widgets.dart';

class RoleSettingsStatus extends StatelessWidget {
  final FunctionalRole role;

  const RoleSettingsStatus({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return RoleSettingsCard(
      title: 'Role Status',
      subtitle: 'Current status of this functional role.',
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: role.isActive
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            role.isActive ? 'Active' : 'Inactive',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              role.isActive
                  ? 'This role is currently available for assignment.'
                  : 'This role is currently inactive.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.lock_outline, size: 17, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}
