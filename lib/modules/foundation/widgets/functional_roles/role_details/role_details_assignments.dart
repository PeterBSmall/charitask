import 'package:flutter/material.dart';

import '../../../domain/models/functional_role.dart';

class RoleDetailsAssignments extends StatelessWidget {
  final FunctionalRole role;

  const RoleDetailsAssignments({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Assignments',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.assignment_outlined, color: Color(0xFF5B3FD3)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Assignment scope and organizational assignments for ${role.name} will be displayed here.',
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ),
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
