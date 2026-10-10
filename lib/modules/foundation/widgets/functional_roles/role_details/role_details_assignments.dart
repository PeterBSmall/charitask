import 'package:flutter/material.dart';

import '../../../data/services/functional_role_service.dart';
import '../../../domain/models/functional_role.dart';

class RoleDetailsAssignments extends StatefulWidget {
  final String organizationId;
  final FunctionalRole role;

  const RoleDetailsAssignments({
    super.key,
    required this.organizationId,
    required this.role,
  });

  @override
  State<RoleDetailsAssignments> createState() => _RoleDetailsAssignmentsState();
}

class _RoleDetailsAssignmentsState extends State<RoleDetailsAssignments> {
  final _service = FunctionalRoleService();

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _assignments = [];
  String? _endingAssignmentId;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  @override
  void didUpdateWidget(covariant RoleDetailsAssignments oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.role.id != widget.role.id ||
        oldWidget.organizationId != widget.organizationId) {
      _loadAssignments();
    }
  }

  Future<void> _loadAssignments() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await _service.getAssignmentsWithPeople(
        organizationId: widget.organizationId,
        roleId: widget.role.id,
        activeOnly: false,
      );

      if (!mounted) return;

      setState(() {
        _assignments = results;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Unable to load assignments for this role.';
      });
    }
  }

  Future<void> _endAssignment(Map<String, dynamic> item) async {
    final assignment = item['assignment'];

    if (assignment == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('End Assignment?'),
          content: Text(
            'This will end the assignment for ${_personName(item)}. '
            'The person will no longer have this functional role.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB91C1C),
              ),
              child: const Text('End Assignment'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final assignmentId = assignment.id?.toString();

    if (assignmentId == null || assignmentId.isEmpty) return;

    setState(() {
      _endingAssignmentId = assignmentId;
    });

    try {
      await _service.endAssignment(
        organizationId: widget.organizationId,
        assignmentId: assignmentId,
      );

      if (!mounted) return;

      await _loadAssignments();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to end this assignment.')),
      );

      setState(() {
        _endingAssignmentId = null;
      });
    }
  }

  String _personName(Map<String, dynamic> item) {
    final person = item['person'];

    if (person == null) {
      return 'this person';
    }

    final preferredName = person['preferred_name']?.toString().trim() ?? '';
    final firstName = person['first_name']?.toString().trim() ?? '';
    final lastName = person['last_name']?.toString().trim() ?? '';

    return [
          preferredName.isNotEmpty ? preferredName : firstName,
          lastName,
        ].where((value) => value.isNotEmpty).join(' ').trim().isEmpty
        ? 'this person'
        : [
            preferredName.isNotEmpty ? preferredName : firstName,
            lastName,
          ].where((value) => value.isNotEmpty).join(' ');
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Assignments',
      trailing: Text(
        '${_assignments.length}',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF64748B),
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _error!,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _loadAssignments,
            icon: const Icon(Icons.refresh_outlined, size: 17),
            label: const Text('Try Again'),
          ),
        ],
      );
    }

    if (_assignments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No assignments have been made to this role.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
      );
    }

    return Column(children: _assignments.map(_buildAssignment).toList());
  }

  Widget _buildAssignment(Map<String, dynamic> item) {
    final assignment = item['assignment'];
    final person = item['person'];

    final active = assignment?.isActive == true;
    final assignmentId = assignment?.id?.toString();

    final ending =
        assignmentId != null &&
        assignmentId.isNotEmpty &&
        assignmentId == _endingAssignmentId;

    final email = person?['email']?.toString().trim() ?? '';

    DateTime? assignedAt;

    if (assignment?.assignedAt is DateTime) {
      assignedAt = assignment.assignedAt as DateTime;
    }

    final personContent = Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFF0EBFF),
          child: Icon(Icons.person_outline, color: Color(0xFF5B3FD3)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _personName(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              if (email.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    final details = Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        const _Detail(icon: Icons.public_outlined, text: 'Organization-Wide'),
        _Detail(
          icon: Icons.calendar_today_outlined,
          text: 'Assigned ${_formatDate(assignedAt)}',
        ),
        _StatusBadge(active: active),
      ],
    );

    final action = active
        ? TextButton(
            onPressed: ending ? null : () => _endAssignment(item),
            child: ending
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('End Assignment'),
          )
        : const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 600;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                personContent,
                const SizedBox(height: 12),
                details,
                if (active) ...[
                  const SizedBox(height: 4),
                  Align(alignment: Alignment.centerLeft, child: action),
                ],
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: personContent),
              const SizedBox(width: 16),
              Flexible(child: details),
              const SizedBox(width: 8),
              action,
            ],
          );
        },
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Detail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: active ? const Color(0xFF166534) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Card({required this.title, required this.child, this.trailing});

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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
