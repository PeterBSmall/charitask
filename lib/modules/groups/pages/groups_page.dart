import 'package:flutter/material.dart';

import 'package:charitask/modules/groups/data/services/group_service.dart';
import 'package:charitask/modules/groups/domain/models/group.dart';

class GroupsPage extends StatefulWidget {
  final String organizationId;

  const GroupsPage({super.key, required this.organizationId});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final GroupService _groupService = GroupService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final groups = await _groupService.getGroups(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _groups = [];
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Groups'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: RefreshIndicator(onRefresh: _loadGroups, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 120),
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Color(0xFFB42318),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Unable to load groups',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _loadGroups,
              child: const Text('Try Again'),
            ),
          ),
        ],
      );
    }

    if (_groups.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: const [
          SizedBox(height: 120),
          Icon(Icons.groups_outlined, size: 56, color: Color(0xFF5B4BC4)),
          SizedBox(height: 16),
          Center(
            child: Text(
              'No groups yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'Create your first group to organize people across your organization.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _groups.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final group = _groups[index];

        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFEDE9FE),
              foregroundColor: Color(0xFF5B4BC4),
              child: Icon(Icons.groups_outlined),
            ),
            title: Text(
              group.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle:
                group.description == null || group.description!.trim().isEmpty
                ? null
                : Text(group.description!),
          ),
        );
      },
    );
  }
}
