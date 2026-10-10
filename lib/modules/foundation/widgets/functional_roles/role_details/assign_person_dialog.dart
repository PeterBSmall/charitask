import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/services/functional_role_service.dart';
import '../../../domain/models/functional_role.dart';
import '../../../../people/data/services/people_service.dart';

class AssignPersonDialog extends StatefulWidget {
  final String organizationId;
  final FunctionalRole role;
  final Set<String> assignedPersonIds;

  const AssignPersonDialog({
    super.key,
    required this.organizationId,
    required this.role,
    required this.assignedPersonIds,
  });

  @override
  State<AssignPersonDialog> createState() => _AssignPersonDialogState();
}

class _AssignPersonDialogState extends State<AssignPersonDialog> {
  final _peopleService = PeopleService(Supabase.instance.client);
  final _roleService = FunctionalRoleService();

  bool _loading = true;
  bool _saving = false;
  String? _error;

  List<Map<String, dynamic>> _people = [];
  String _search = '';
  String? _selectedPersonId;

  @override
  void initState() {
    super.initState();
    _loadPeople();
  }

  Future<void> _loadPeople() async {
    try {
      final people = await _peopleService.getPeople(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _people = people.where((person) {
          final id = person['id']?.toString();
          final status = person['status']?.toString();

          return id != null &&
              !widget.assignedPersonIds.contains(id) &&
              status != 'inactive';
        }).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Unable to load people.';
      });
    }
  }

  List<Map<String, dynamic>> get _filteredPeople {
    final query = _search.trim().toLowerCase();

    if (query.isEmpty) {
      return _people;
    }

    return _people.where((person) {
      final name = _personName(person).toLowerCase();
      final email = person['email']?.toString().toLowerCase() ?? '';

      return name.contains(query) || email.contains(query);
    }).toList();
  }

  String _personName(Map<String, dynamic> person) {
    final preferred = person['preferred_name']?.toString().trim() ?? '';
    final first = person['first_name']?.toString().trim() ?? '';
    final last = person['last_name']?.toString().trim() ?? '';

    return [
      preferred.isNotEmpty ? preferred : first,
      last,
    ].where((value) => value.isNotEmpty).join(' ');
  }

  Future<void> _assign() async {
    final personId = _selectedPersonId;

    if (personId == null || _saving) {
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await _roleService.createAssignment(
        organizationId: widget.organizationId,
        personId: personId,
        functionalRoleId: widget.role.id,
        workspaceId: null,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _saving = false;
        _error = 'Unable to assign this person to the role.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Assign Person'),
      content: SizedBox(width: 520, child: _buildContent()),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedPersonId == null || _saving ? null : _assign,
          child: _saving
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Assign Person'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null && _people.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(
            _error!,
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
        ),
      );
    }

    if (_people.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(
          child: Text(
            'All active people are already assigned to this role.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              _search = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search people...',
            prefixIcon: const Icon(Icons.search_outlined, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        _buildScope(),
        const SizedBox(height: 12),
        if (_error != null) ...[_buildError(), const SizedBox(height: 8)],
        SizedBox(height: 280, child: _buildPeopleList()),
      ],
    );
  }

  Widget _buildScope() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Row(
        children: [
          Icon(Icons.public_outlined, size: 19, color: Color(0xFF5B3FD3)),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organization Wide',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'This role assignment applies across the organization.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleList() {
    final people = _filteredPeople;

    if (people.isEmpty) {
      return const Center(
        child: Text(
          'No matching people found.',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
      );
    }

    return ListView.separated(
      itemCount: people.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final person = people[index];
        final id = person['id']?.toString();

        if (id == null) {
          return const SizedBox.shrink();
        }

        final selected = id == _selectedPersonId;
        final name = _personName(person);
        final email = person['email']?.toString().trim() ?? '';

        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _saving
              ? null
              : () {
                  setState(() {
                    _selectedPersonId = id;
                  });
                },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFF0EBFF) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected
                    ? const Color(0xFF5B3FD3)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: selected
                      ? const Color(0xFFE3DBFF)
                      : const Color(0xFFF1F5F9),
                  child: Icon(
                    Icons.person_outline,
                    size: 19,
                    color: selected
                        ? const Color(0xFF5B3FD3)
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isEmpty ? 'Unnamed Person' : name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
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
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                    ],
                  ),
                ),
                if (selected)
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Color(0xFF5B3FD3),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildError() {
    return Text(
      _error!,
      style: const TextStyle(fontSize: 12, color: Color(0xFFB91C1C)),
    );
  }
}
