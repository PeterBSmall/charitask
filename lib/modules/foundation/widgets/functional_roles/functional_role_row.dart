import 'package:flutter/material.dart';

import '../../domain/models/functional_role.dart';
import '../../domain/models/functional_role_category.dart';

class FunctionalRoleRow extends StatelessWidget {
  final FunctionalRole role;
  final FunctionalRoleCategory category;
  final int peopleCount;
  final VoidCallback? onTap;

  const FunctionalRoleRow({
    super.key,
    required this.role,
    required this.category,
    this.peopleCount = 0,
    this.onTap,
  });

  String get _peopleLabel {
    return peopleCount == 1 ? '1 Person' : '$peopleCount People';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;

        return Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: compact ? _buildCompact() : _buildDesktop(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktop() {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildRoleName()),
        Expanded(flex: 2, child: _buildCategory()),
        Expanded(flex: 1, child: _buildType()),
        Expanded(flex: 1, child: _buildPeople()),
        Expanded(flex: 1, child: _buildStatus()),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
      ],
    );
  }

  Widget _buildCompact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildRoleName()),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF94A3B8)),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCategory(),
            _buildType(),
            _buildPeople(),
            _buildStatus(),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleName() {
    return Text(
      role.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildCategory() {
    return _MetaText(icon: Icons.category_outlined, text: category.name);
  }

  Widget _buildType() {
    return _RoleTypeBadge(imported: role.isImported);
  }

  Widget _buildPeople() {
    final unassigned = peopleCount == 0;

    return _MetaText(
      icon: Icons.groups_outlined,
      text: _peopleLabel,
      muted: unassigned,
    );
  }

  Widget _buildStatus() {
    return const _StatusBadge(label: 'Active', active: true);
  }
}

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool muted;

  const _MetaText({required this.icon, required this.text, this.muted = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: muted ? const Color(0xFFB45309) : const Color(0xFF64748B),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: muted ? const Color(0xFFB45309) : const Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleTypeBadge extends StatelessWidget {
  final bool imported;

  const _RoleTypeBadge({required this.imported});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: imported ? const Color(0xFFF1F5F9) : const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        imported ? 'Imported' : 'Custom',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: imported ? const Color(0xFF64748B) : const Color(0xFF7C3AED),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool active;

  const _StatusBadge({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: active ? const Color(0xFF047857) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}
