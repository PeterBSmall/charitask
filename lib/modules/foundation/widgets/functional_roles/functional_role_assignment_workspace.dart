import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role_category.dart';

import 'functional_role_categories.dart';
import 'functional_role_catalog.dart';
import 'selected_functional_roles.dart';

class FunctionalRoleAssignmentWorkspace extends StatefulWidget {
  final String organizationId;
  final bool canCreateRole;
  final VoidCallback? onCreateRole;
  final VoidCallback? onCancel;
  final ValueChanged<List<FunctionalRole>>? onSave;
  final List<FunctionalRole> initialSelectedRoles;
  final bool embedded;

  const FunctionalRoleAssignmentWorkspace({
    super.key,
    required this.organizationId,
    this.canCreateRole = false,
    this.onCreateRole,
    this.onCancel,
    this.onSave,
    this.initialSelectedRoles = const [],
    this.embedded = false,
  });

  @override
  State<FunctionalRoleAssignmentWorkspace> createState() =>
      _FunctionalRoleAssignmentWorkspaceState();
}

class _FunctionalRoleAssignmentWorkspaceState
    extends State<FunctionalRoleAssignmentWorkspace> {
  late final FunctionalRoleService _service;

  List<FunctionalRoleCategory> _categories = [];
  List<FunctionalRole> _roles = [];
  List<FunctionalRole> _selectedRoles = [];

  String? _selectedCategoryId;
  String _searchQuery = '';

  bool _isLoading = true;
  String? _errorMessage;

  static const _purple = Color(0xFF5B3FD3);
  static const _darkText = Color(0xFF172554);
  static const _mutedText = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();

    _service = FunctionalRoleService();
    _selectedRoles = List<FunctionalRole>.from(widget.initialSelectedRoles);

    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final results = await Future.wait([
        _service.getCategories(organizationId: widget.organizationId),
        _service.getRoles(organizationId: widget.organizationId),
      ]);

      if (!mounted) return;

      setState(() {
        _categories = results[0] as List<FunctionalRoleCategory>;
        _roles = results[1] as List<FunctionalRole>;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load functional roles.';
      });
    }
  }

  List<FunctionalRole> get _filteredRoles {
    Iterable<FunctionalRole> result = _roles;

    if (_selectedCategoryId != null) {
      result = result.where((role) => role.categoryId == _selectedCategoryId);
    }

    final query = _searchQuery.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where((role) {
        final name = role.name.toLowerCase();
        final description = role.description?.toLowerCase() ?? '';
        final category = role.categoryName?.toLowerCase() ?? '';

        return name.contains(query) ||
            description.contains(query) ||
            category.contains(query);
      });
    }

    final filtered = result.toList();

    filtered.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return filtered;
  }

  void _selectCategory(String? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  void _updateSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _toggleRole(FunctionalRole role) {
    setState(() {
      final index = _selectedRoles.indexWhere(
        (selected) => selected.id == role.id,
      );

      if (index >= 0) {
        _selectedRoles.removeAt(index);
      } else {
        _selectedRoles.add(role);
      }
    });
  }

  void _removeRole(FunctionalRole role) {
    setState(() {
      _selectedRoles.removeWhere((selected) => selected.id == role.id);
    });
  }

  void _save() {
    widget.onSave?.call(List.unmodifiable(_selectedRoles));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EBFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.work_rounded, color: _purple, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assign Functional Roles',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: _darkText,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Select the functional roles this person performs in your organization.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: _mutedText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (_selectedRoles.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBFF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '${_selectedRoles.length} selected',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _purple,
                ),
              ),
            ),
          if (widget.onCancel != null) ...[
            const SizedBox(width: 10),
            IconButton(
              tooltip: 'Close',
              onPressed: widget.onCancel,
              icon: const Icon(Icons.close, color: Color(0xFF475569)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _purple));
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        /*
         * The target design is a true three-column workspace.
         *
         * At 1100px and above we keep all three panels visible.
         * Below that, we switch to a vertically scrollable workspace
         * rather than forcing three columns into too little space.
         */
        if (constraints.maxWidth >= 1100) {
          return _buildDesktopWorkspace();
        }

        return _buildCompactWorkspace();
      },
    );
  }

  Widget _buildDesktopWorkspace() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 23, child: _buildCategoriesPanel()),
        Expanded(flex: 35, child: _buildCatalogPanel()),
        Expanded(flex: 42, child: _buildSelectedRolesPanel()),
      ],
    );
  }

  Widget _buildCategoriesPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAFBFD),
        border: Border(right: BorderSide(color: _border)),
      ),
      child: FunctionalRoleCategories(
        categories: _categories,
        selectedCategoryId: _selectedCategoryId,
        onCategorySelected: _selectCategory,
      ),
    );
  }

  Widget _buildCatalogPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: _border)),
      ),
      child: FunctionalRoleCatalog(
        roles: _filteredRoles,
        selectedRoleIds: _selectedRoles.map((role) => role.id).toSet(),
        searchQuery: _searchQuery,
        onSearchChanged: _updateSearch,
        onRoleToggled: _toggleRole,
        onCreateRole: widget.canCreateRole ? widget.onCreateRole : null,
      ),
    );
  }

  Widget _buildSelectedRolesPanel() {
    return Container(
      color: const Color(0xFFFCFCFD),
      child: SelectedFunctionalRoles(
        roles: _selectedRoles,
        onRemove: _removeRole,
      ),
    );
  }

  Widget _buildCompactWorkspace() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: _border)),
            ),
            child: const TabBar(
              isScrollable: false,
              labelColor: _purple,
              unselectedLabelColor: Color(0xFF64748B),
              indicatorColor: _purple,
              indicatorWeight: 2,
              tabs: [
                Tab(text: 'Categories'),
                Tab(text: 'Role Catalog'),
                Tab(text: 'Selected'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildCategoriesPanel(),
                _buildCatalogPanel(),
                _buildSelectedRolesPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 42, color: Color(0xFFDC2626)),
            const SizedBox(height: 12),
            const Text(
              'Unable to load functional roles',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh, size: 17),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    if (widget.embedded) {
      return Container(
        padding: const EdgeInsets.fromLTRB(18, 11, 18, 11),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _border)),
        ),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: widget.onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: _purple,
                side: const BorderSide(color: Color(0xFFC9B9FF)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Done'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _selectedRoles.isEmpty ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: _purple,
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
              ),
              child: const Text('Apply Changes'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 11, 18, 11),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: widget.onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: _purple,
              side: const BorderSide(color: Color(0xFFC9B9FF)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          const Spacer(),
          FilledButton(
            onPressed: _selectedRoles.isEmpty ? null : _save,
            style: FilledButton.styleFrom(
              backgroundColor: _purple,
              disabledBackgroundColor: const Color(0xFFE2E8F0),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            ),
            child: const Text('Save Assignments'),
          ),
        ],
      ),
    );
  }
}
