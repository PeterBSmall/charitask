import 'package:flutter/material.dart';

import '../../domain/models/functional_role.dart';
import '../../domain/models/functional_role_category.dart';
import '../../data/services/functional_role_service.dart';
import 'functional_role_row.dart';

class FunctionalRolesList extends StatefulWidget {
  final String organizationId;
  final void Function(FunctionalRoleCategory category, FunctionalRole role)?
  onRoleSelected;

  const FunctionalRolesList({
    super.key,
    required this.organizationId,
    this.onRoleSelected,
  });

  @override
  State<FunctionalRolesList> createState() => _FunctionalRolesListState();
}

class _FunctionalRolesListState extends State<FunctionalRolesList> {
  final FunctionalRoleService _service = FunctionalRoleService();

  bool _loading = true;
  String? _error;

  List<FunctionalRoleCategory> _categories = [];
  List<FunctionalRole> _roles = [];

  final Map<String, int> _peopleCounts = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final categories = await _service.getCategories(
        organizationId: widget.organizationId,
      );

      final roles = await _service.getRoles(
        organizationId: widget.organizationId,
      );

      final assignments = await _service.getAssignments(
        organizationId: widget.organizationId,
        activeOnly: true,
      );

      final peopleByRole = <String, Set<String>>{};

      for (final assignment in assignments) {
        peopleByRole
            .putIfAbsent(assignment.functionalRoleId, () => <String>{})
            .add(assignment.personId);
      }

      final peopleCounts = <String, int>{};

      for (final entry in peopleByRole.entries) {
        peopleCounts[entry.key] = entry.value.length;
      }

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _roles = roles;
        _peopleCounts
          ..clear()
          ..addAll(peopleCounts);
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  FunctionalRoleCategory? _categoryForRole(FunctionalRole role) {
    for (final category in _categories) {
      if (category.id == role.categoryId) {
        return category;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildLoading();
    }

    if (_error != null) {
      return _buildError();
    }

    if (_roles.isEmpty) {
      return _buildEmpty();
    }

    return _buildList();
  }

  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unable to load functional roles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Icon(Icons.badge_outlined, size: 42, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            'No functional roles found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final categoryMap = {
      for (final category in _categories) category.id: category,
    };

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;

          return Column(
            children: [
              if (!compact) _buildColumnHeader(),
              ..._roles.map((role) {
                final category =
                    categoryMap[role.categoryId] ?? _categoryForRole(role);

                if (category == null) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    FunctionalRoleRow(
                      role: role,
                      category: category,
                      peopleCount: _peopleCounts[role.id] ?? 0,
                      onTap: () {
                        widget.onRoleSelected?.call(category, role);
                      },
                    ),
                    if (role != _roles.last)
                      const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildColumnHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      color: const Color(0xFFF8FAFC),
      child: const Row(
        children: [
          Expanded(flex: 3, child: _HeaderText('Role')),
          Expanded(flex: 2, child: _HeaderText('Category')),
          Expanded(flex: 1, child: _HeaderText('Type')),
          Expanded(flex: 1, child: _HeaderText('People')),
          Expanded(flex: 1, child: _HeaderText('Status')),
          SizedBox(width: 28),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;

  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF64748B),
      ),
    );
  }
}
