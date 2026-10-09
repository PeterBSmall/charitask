import 'package:flutter/material.dart';

import '../../../domain/models/functional_role.dart';
import '../../../domain/models/functional_role_category.dart';

class RoleDetailsOverview extends StatelessWidget {
  final FunctionalRoleCategory category;
  final FunctionalRole role;

  const RoleDetailsOverview({
    super.key,
    required this.category,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Overview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Field(label: 'Role Category', value: category.name),
          const SizedBox(height: 16),
          _Field(
            label: 'Role Type',
            value: role.isImported ? 'System Role' : 'Custom Role',
          ),
          const SizedBox(height: 16),
          _Field(label: 'Status', value: role.isActive ? 'Active' : 'Inactive'),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;

  const _Field({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
        ),
      ],
    );
  }
}
