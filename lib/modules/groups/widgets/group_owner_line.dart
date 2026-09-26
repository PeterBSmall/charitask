import 'package:flutter/material.dart';

import '../domain/models/group.dart';

class GroupOwnerLine extends StatelessWidget {
  final GroupOwnerType? ownerType;

  const GroupOwnerLine({super.key, required this.ownerType});

  static const _navy = Color(0xFF1E293B);
  static const _gray = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final type = ownerType;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_iconFor(type), size: 15, color: _gray),
        const SizedBox(width: 6),
        const Text(
          'Owned By',
          style: TextStyle(
            color: _gray,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          _labelFor(type),
          style: const TextStyle(
            color: _navy,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _labelFor(GroupOwnerType? type) {
    switch (type) {
      case GroupOwnerType.organization:
        return 'Organization';
      case GroupOwnerType.program:
        return 'Program';
      case GroupOwnerType.location:
        return 'Location';
      case GroupOwnerType.event:
        return 'Event';
      case GroupOwnerType.project:
        return 'Project';
      case null:
        return 'Not Assigned';
    }
  }

  IconData _iconFor(GroupOwnerType? type) {
    switch (type) {
      case GroupOwnerType.organization:
        return Icons.business_outlined;
      case GroupOwnerType.program:
        return Icons.account_tree_outlined;
      case GroupOwnerType.location:
        return Icons.location_on_outlined;
      case GroupOwnerType.event:
        return Icons.event_outlined;
      case GroupOwnerType.project:
        return Icons.work_outline_rounded;
      case null:
        return Icons.help_outline_rounded;
    }
  }
}
