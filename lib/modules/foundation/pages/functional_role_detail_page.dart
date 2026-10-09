import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role_category.dart';

class FunctionalRoleDetailPage extends StatefulWidget {
  final String organizationId;
  final FunctionalRoleCategory category;
  final FunctionalRole role;
  final VoidCallback onBack;

  const FunctionalRoleDetailPage({
    super.key,
    required this.organizationId,
    required this.category,
    required this.role,
    required this.onBack,
  });

  @override
  State<FunctionalRoleDetailPage> createState() =>
      _FunctionalRoleDetailPageState();
}

class _FunctionalRoleDetailPageState extends State<FunctionalRoleDetailPage> {
  int _selectedTab = 0;
  final FunctionalRoleService _functionalRoleService = FunctionalRoleService();

  bool _peopleLoading = false;
  String? _peopleError;
  List<Map<String, dynamic>> _assignedPeople = [];

  static const _purple = Color(0xFF5B3FD3);
  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  static const _tabs = [
    'Overview',
    'People',
    'Permissions',
    'Activity',
    'Settings',
  ];
  @override
  void initState() {
    super.initState();
    _loadAssignedPeople();
  }

  Future<void> _loadAssignedPeople() async {
    setState(() {
      _peopleLoading = true;
      _peopleError = null;
    });

    try {
      final results = await _functionalRoleService.getAssignmentsWithPeople(
        organizationId: widget.organizationId,
        roleId: widget.role.id,
      );

      if (!mounted) return;

      setState(() {
        _assignedPeople = results;
        _peopleLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _peopleLoading = false;
        _peopleError = error.toString();
      });
    }
  }

  Widget _buildPeopleEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'No people are currently assigned to this role.',
          style: TextStyle(fontSize: 14, color: _muted),
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

  Widget _buildPeopleError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'We couldn’t load the people assigned to this role.',
          style: TextStyle(fontSize: 14, color: _muted),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: _loadAssignedPeople,
          icon: const Icon(Icons.refresh_outlined, size: 17),
          label: const Text('Try Again'),
        ),
      ],
    );
  }

  Widget _buildAssignedPerson(Map<String, dynamic> item) {
    final assignment = item['assignment'];
    final person = item['person'];

    final firstName =
        person?['preferred_name']?.toString().trim().isNotEmpty == true
        ? person['preferred_name'].toString().trim()
        : person?['first_name']?.toString().trim() ?? '';

    final lastName = person?['last_name']?.toString().trim() ?? '';

    final fullName = '$firstName $lastName'.trim();

    final email = person?['email']?.toString().trim() ?? '';
    final isActive = assignment?.isActive == true;

    final assignedAt = assignment?.assignedAt;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_outline, size: 21, color: _purple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName.isEmpty ? 'Unnamed Person' : fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _text,
                    ),
                  ),
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: _muted),
                    ),
                  ],
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _AssignmentStatusBadge(isActive: isActive),
                      if (assignedAt is DateTime)
                        Text(
                          'Assigned ${_formatDate(assignedAt)}',
                          style: const TextStyle(fontSize: 11, color: _muted),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: widget.onBack,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 7),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 19,
                            color: Color(0xFF1E293B),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Back to Functional Roles',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              _buildBreadcrumb(widget.category, widget.role),

              _buildHeader(widget.role, widget.category),

              _buildTabs(),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: _buildTabContent(widget.role, widget.category),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(
    FunctionalRoleCategory category,
    FunctionalRole role,
  ) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        InkWell(
          onTap: widget.onBack,
          borderRadius: BorderRadius.circular(6),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              'Functional Roles',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _purple,
              ),
            ),
          ),
        ),
        const Icon(Icons.chevron_right, size: 16, color: _muted),
        InkWell(
          onTap: widget.onBack,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _purple,
              ),
            ),
          ),
        ),
        const Icon(Icons.chevron_right, size: 16, color: _muted),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            role.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _muted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(FunctionalRole role, FunctionalRoleCategory category) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;

          final identity = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EBFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: _purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _OriginBadge(isImported: role.isImported),
                        _InfoChip(label: category.name),
                      ],
                    ),
                    if (role.description?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 12),
                      Text(
                        role.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: _muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );

          final actions = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.edit_outlined, size: 17),
                label: const Text('Edit'),
              ),
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.copy_outlined, size: 17),
                label: const Text('Duplicate'),
              ),
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.archive_outlined, size: 17),
                label: const Text('Archive'),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [identity, const SizedBox(height: 18), actions],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: identity),
              const SizedBox(width: 20),
              actions,
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;

          if (compact) {
            return Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(
                _tabs.length,
                (index) => _TabButton(
                  label: _tabs[index],
                  selected: _selectedTab == index,
                  onTap: () {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                ),
              ),
            );
          }

          return Row(
            children: List.generate(
              _tabs.length,
              (index) => Expanded(
                child: _TabButton(
                  label: _tabs[index],
                  selected: _selectedTab == index,
                  onTap: () {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent(
    FunctionalRole role,
    FunctionalRoleCategory category,
  ) {
    switch (_selectedTab) {
      case 1:
        return _buildPeople();
      case 2:
        return _buildPermissions();
      case 3:
        return _buildActivity();
      case 4:
        return _buildSettings();
      default:
        return _buildOverview(role, category);
    }
  }

  Widget _buildOverview(FunctionalRole role, FunctionalRoleCategory category) {
    return _ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _text,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _Metric(
                label: 'Assignments',
                value: '${role.assignmentCount}',
                icon: Icons.people_outline,
              ),
              _Metric(
                label: 'Source',
                value: role.isImported ? 'Imported' : 'Custom',
                icon: Icons.library_books_outlined,
              ),
            ],
          ),
          const SizedBox(height: 22),
          _DetailField(label: 'Category', value: category.name),
          const SizedBox(height: 16),
          _DetailField(
            label: 'Status',
            value: role.isActive ? 'Active' : 'Inactive',
          ),
          if (role.isImported) ...[
            const SizedBox(height: 16),
            _DetailField(label: 'Based On', value: role.name),
          ],
        ],
      ),
    );
  }

  Widget _buildPeople() {
    return _ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assigned People',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _text,
            ),
          ),
          const SizedBox(height: 18),
          if (_peopleLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_peopleError != null)
            _buildPeopleError()
          else if (_assignedPeople.isEmpty)
            _buildPeopleEmptyState()
          else
            Column(
              children: _assignedPeople
                  .map((item) => _buildAssignedPerson(item))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPermissions() {
    return const _ContentCard(
      child: Text(
        'Role permissions will be configured here.',
        style: TextStyle(fontSize: 14, color: _muted),
      ),
    );
  }

  Widget _buildActivity() {
    return const _ContentCard(
      child: Text(
        'Role activity will appear here.',
        style: TextStyle(fontSize: 14, color: _muted),
      ),
    );
  }

  Widget _buildSettings() {
    return const _ContentCard(
      child: Text(
        'Role settings will appear here.',
        style: TextStyle(fontSize: 14, color: _muted),
      ),
    );
  }
}

class _AssignmentStatusBadge extends StatelessWidget {
  final bool isActive;

  const _AssignmentStatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE8F7EE) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isActive ? const Color(0xFF15803D) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  final Widget child;

  const _ContentCard({required this.child});

  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }
}

class _OriginBadge extends StatelessWidget {
  final bool isImported;

  const _OriginBadge({required this.isImported});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isImported ? const Color(0xFFF0EBFF) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isImported ? 'Imported Role' : 'Custom Role',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isImported ? const Color(0xFF5B3FD3) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _Metric({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;

  const _DetailField({required this.label, required this.value});

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

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected
                  ? const Color(0xFF5B3FD3)
                  : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }
}
