import 'package:flutter/material.dart';

import '../../../data/services/functional_role_service.dart';
import '../../../domain/models/functional_role.dart';

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

  bool _loading = true;
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
      final results = await _service.getAssignmentsWithPeople(
        organizationId: widget.organizationId,
        roleId: widget.role.id,
      );

      if (!mounted) return;

      setState(() {
        _people = results;
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

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Assigned People',
      trailing: Text(
        '${_people.length}',
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
            onPressed: _loadPeople,
            icon: const Icon(Icons.refresh_outlined, size: 17),
            label: const Text('Try Again'),
          ),
        ],
      );
    }

    if (_people.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'No people are currently assigned to this role.',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.person_add_outlined, size: 17),
            label: const Text('Assign Person'),
          ),
        ],
      );
    }

    return Column(children: _people.map(_buildPerson).toList());
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
                if (email.isNotEmpty)
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
            ),
          ),
          const SizedBox(width: 8),
          _StatusBadge(active: active),
        ],
      ),
    );
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
