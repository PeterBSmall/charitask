import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/services/functional_role_service.dart';
import '../../../domain/models/functional_role.dart';
import '../../../../../platform/authorization/authorization.dart'
    hide FunctionalRole, Permission;
import '../role_details/assign_person_dialog.dart';

class RoleDetailsPeople extends StatefulWidget {
  final String organizationId;
  final FunctionalRole role;

  const RoleDetailsPeople({
    super.key,
    required this.organizationId,
    required this.role,
  });

  @override
  State<RoleDetailsPeople> createState() => _RoleDetailsPeopleState();
}

class _RoleDetailsPeopleState extends State<RoleDetailsPeople> {
  final _service = FunctionalRoleService();

  late final AuthorizationService _authorizationService = AuthorizationService(
    Supabase.instance.client,
  );

  bool _loading = true;
  bool _canManage = false;
  String? _error;
  List<Map<String, dynamic>> _people = [];

  @override
  void initState() {
    super.initState();
    _loadPeople();
  }

  @override
  void didUpdateWidget(covariant RoleDetailsPeople oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.role.id != widget.role.id ||
        oldWidget.organizationId != widget.organizationId) {
      _loadPeople();
    }
  }

  Future<void> _loadPeople() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        _service.getAssignmentsWithPeople(
          organizationId: widget.organizationId,
          roleId: widget.role.id,
        ),
        _authorizationService.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'functionalrole.manage',
        ),
      ]);

      if (!mounted) return;

      setState(() {
        _people = results[0] as List<Map<String, dynamic>>;
        _canManage = results[1] as bool;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Unable to load people assigned to this role.';
      });
    }
  }

  Future<void> _assignPerson() async {
    final assignedPersonIds = _people
        .map((item) {
          final person = item['person'];

          if (person is Map<String, dynamic>) {
            return person['id']?.toString();
          }

          return null;
        })
        .whereType<String>()
        .toSet();

    final assigned = await showDialog<bool>(
      context: context,
      builder: (_) => AssignPersonDialog(
        organizationId: widget.organizationId,
        role: widget.role,
        assignedPersonIds: assignedPersonIds,
      ),
    );

    if (assigned == true && mounted) {
      await _loadPeople();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Assigned People',
      trailing: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            '${_people.length}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
            ),
          ),
          if (_canManage)
            OutlinedButton.icon(
              onPressed: _loading ? null : _assignPerson,
              icon: const Icon(Icons.person_add_outlined, size: 17),
              label: const Text('Assign Person'),
            ),
        ],
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return _buildError();
    }

    if (_people.isEmpty) {
      return const Text(
        'No people are currently assigned to this role.',
        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
      );
    }

    return Column(children: _people.map(_buildPerson).toList());
  }

  Widget _buildError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _error!,
          style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _loadPeople,
          icon: const Icon(Icons.refresh_outlined, size: 17),
          label: const Text('Try Again'),
        ),
      ],
    );
  }

  Widget _buildPerson(Map<String, dynamic> item) {
    final person = item['person'];
    final assignment = item['assignment'];

    final preferredName = person?['preferred_name']?.toString().trim() ?? '';

    final firstName = person?['first_name']?.toString().trim() ?? '';

    final lastName = person?['last_name']?.toString().trim() ?? '';

    final name = [
      preferredName.isNotEmpty ? preferredName : firstName,
      lastName,
    ].where((value) => value.isNotEmpty).join(' ');

    final email = person?['email']?.toString().trim() ?? '';
    final active = assignment?.isActive == true;
    final assignedAt = assignment?.assignedAt;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              children: [
                Text(
                  name.isEmpty ? 'Unnamed Person' : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 3),
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
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _StatusBadge(active: active),
                    if (assignedAt is DateTime)
                      Text(
                        'Assigned ${_formatDate(assignedAt)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8F7EE) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: active ? const Color(0xFF15803D) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;

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
