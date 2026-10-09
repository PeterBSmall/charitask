import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/functional_role.dart';

class RoleCategoryRoles extends StatelessWidget {
  final List<FunctionalRole> roles;
  final String? selectedRoleId;
  final ValueChanged<String> onRoleSelected;

  const RoleCategoryRoles({
    super.key,
    required this.roles,
    required this.selectedRoleId,
    required this.onRoleSelected,
  });

  static const _muted = Color(0xFF64748B);

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
        ...roles.map(
          (role) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _RoleRow(
              role: role,
              selected: role.id == selectedRoleId,
              onTap: () => onRoleSelected(role.id),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleRow extends StatelessWidget {
  final FunctionalRole role;
  final bool selected;
  final VoidCallback onTap;

  const _RoleRow({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _purple = Color(0xFF5B3FD3);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF0EBFF) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFFD8CCFF) : _border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFE3D9FF)
                      : const Color(0xFFF0EBFF),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  Icons.badge_outlined,
                  size: 19,
                  color: selected ? _purple : _purple,
                ),
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w700,
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _RoleOriginBadge(isImported: role.isImported),
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
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: selected ? _purple : _muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleOriginBadge extends StatelessWidget {
  final bool isImported;

  const _RoleOriginBadge({required this.isImported});

  static const _purple = Color(0xFF5B3FD3);
  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isImported ? const Color(0xFFF0EBFF) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isImported ? 'Imported' : 'Custom',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isImported ? _purple : _muted,
        ),
      ),
    );
  }
}
