import 'package:flutter/material.dart';

import '../../domain/models/functional_role.dart';

class SelectedFunctionalRoleCard extends StatelessWidget {
  const SelectedFunctionalRoleCard({
    super.key,
    required this.role,
    required this.onRemove,
  });

  final FunctionalRole role;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoleHeader(),
            const SizedBox(height: 12),
            _buildStatusRow(),
            const SizedBox(height: 16),
            _buildAssignmentDetails(),
            const SizedBox(height: 16),
            _buildRequirements(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.badge_outlined,
            size: 20,
            color: Color(0xFF0891B2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              if (role.description != null &&
                  role.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  role.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 4),
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: const Icon(
            Icons.more_horiz,
            size: 20,
            color: Color(0xFF64748B),
          ),
          onSelected: (value) {
            if (value == 'remove') {
              onRemove();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'remove', child: Text('Remove Role')),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        const _Badge(
          label: 'New Assignment',
          background: Color(0xFFEDE9FE),
          foreground: Color(0xFF5B3FD3),
        ),
        _Badge(
          label: role.isActive ? 'Active Role' : 'Inactive Role',
          background: role.isActive
              ? const Color(0xFFDCFCE7)
              : const Color(0xFFF1F5F9),
          foreground: role.isActive
              ? const Color(0xFF166534)
              : const Color(0xFF64748B),
        ),
        if (role.categoryName != null && role.categoryName!.trim().isNotEmpty)
          _Badge(
            label: role.categoryName!,
            background: const Color(0xFFF1F5F9),
            foreground: const Color(0xFF475569),
          ),
      ],
    );
  }

  Widget _buildAssignmentDetails() {
    return _Section(
      title: 'Assignment Details',
      icon: Icons.tune_outlined,
      child: Column(
        children: [
          _DetailRow(
            label: 'Location',
            value: 'Not configured',
            icon: Icons.location_on_outlined,
          ),
          const Divider(height: 20, color: Color(0xFFE2E8F0)),
          _DetailRow(
            label: 'Program',
            value: 'Not configured',
            icon: Icons.account_tree_outlined,
          ),
          const Divider(height: 20, color: Color(0xFFE2E8F0)),
          _DetailRow(
            label: 'Group',
            value: 'Not configured',
            icon: Icons.groups_outlined,
          ),
          const Divider(height: 20, color: Color(0xFFE2E8F0)),
          _DetailRow(
            label: 'Start Date',
            value: 'When assignment is saved',
            icon: Icons.calendar_today_outlined,
          ),
          const Divider(height: 20, color: Color(0xFFE2E8F0)),
          _DetailRow(
            label: 'End Date',
            value: 'No end date',
            icon: Icons.event_outlined,
          ),
          const Divider(height: 20, color: Color(0xFFE2E8F0)),
          _DetailRow(
            label: 'Primary Assignment',
            value: 'Not configured',
            icon: Icons.star_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirements() {
    return _Section(
      title: 'Role Requirements',
      icon: Icons.checklist_outlined,
      trailing: const _RequirementStatus(
        label: 'Not configured',
        foreground: Color(0xFF64748B),
        background: Color(0xFFF1F5F9),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 17, color: Color(0xFF94A3B8)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'No role requirements have been configured yet.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF334155),
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }
}

class _RequirementStatus extends StatelessWidget {
  const _RequirementStatus({
    required this.label,
    required this.foreground,
    required this.background,
  });

  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}
