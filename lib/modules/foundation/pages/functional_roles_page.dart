import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../platform/authorization/authorization.dart'
    hide FunctionalRole, Permission;
import '../data/services/functional_role_service.dart';
import '../domain/models/functional_role.dart';
import '../domain/models/functional_role_category.dart';
import '../widgets/functional_roles/create_functional_role_dialog.dart';
import '../widgets/functional_roles/functional_roles_layout.dart';

class FunctionalRolesPage extends StatefulWidget {
  final String organizationId;

  const FunctionalRolesPage({super.key, required this.organizationId});

  @override
  State<FunctionalRolesPage> createState() => _FunctionalRolesPageState();
}

class _FunctionalRolesPageState extends State<FunctionalRolesPage> {
  late final FunctionalRoleService _service;

  final _categorySearchController = TextEditingController();
  final _roleSearchController = TextEditingController();

  List<FunctionalRoleCategory> _categories = [];
  List<FunctionalRole> _roles = [];

  FunctionalRoleCategory? _selectedCategory;
  FunctionalRole? _selectedRole;

  String _roleFilter = 'all';

  bool _canCreateRole = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _service = FunctionalRoleService();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authorization = AuthorizationService(Supabase.instance.client);

      final results = await Future.wait([
        _service.getCategories(organizationId: widget.organizationId),
        _service.getRoles(
          organizationId: widget.organizationId,
          activeOnly: false,
        ),
        authorization.hasPermission(
          organizationId: widget.organizationId,
          permissionKey: 'functionalrole.create',
        ),
      ]);

      if (!mounted) return;

      final categories = List<FunctionalRoleCategory>.from(results[0] as List);

      final roles = List<FunctionalRole>.from(results[1] as List);

      final canCreateRole = results[2] as bool;

      categories.sort((a, b) {
        int priority(String name) {
          switch (name.trim().toLowerCase()) {
            case 'administration':
              return 0;
            case 'leadership':
              return 1;
            default:
              return 2;
          }
        }

        final priorityComparison = priority(a.name).compareTo(priority(b.name));

        if (priorityComparison != 0) {
          return priorityComparison;
        }

        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      roles.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      setState(() {
        _categories = categories;
        _roles = roles;
        _canCreateRole = canCreateRole;
        _isLoading = false;

        if (categories.isNotEmpty) {
          final previousCategoryId = _selectedCategory?.id;

          _selectedCategory = categories.firstWhere(
            (category) => category.id == previousCategoryId,
            orElse: () => categories.first,
          );
        } else {
          _selectedCategory = null;
        }

        final previousRoleId = _selectedRole?.id;

        FunctionalRole? selectedRole;

        if (previousRoleId != null) {
          for (final role in roles) {
            if (role.id == previousRoleId && _matchesRoleFilter(role)) {
              selectedRole = role;
              break;
            }
          }
        }

        selectedRole ??= _firstRoleForCategory(_selectedCategory, roles);

        _selectedRole = selectedRole;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load functional roles.';
      });
    }
  }

  FunctionalRole? _firstRoleForCategory(
    FunctionalRoleCategory? category,
    List<FunctionalRole> roles,
  ) {
    if (category == null) return null;

    for (final role in roles) {
      if (role.categoryId == category.id && _matchesRoleFilter(role)) {
        return role;
      }
    }

    return null;
  }

  void _selectCategory(FunctionalRoleCategory? category) {
    setState(() {
      _selectedCategory = category;
      _selectedRole = _firstRoleForCategory(category, _roles);
    });
  }

  void _selectRole(FunctionalRole? role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _changeRoleFilter(String filter) {
    setState(() {
      _roleFilter = filter;

      if (_selectedRole != null && !_matchesRoleFilter(_selectedRole!)) {
        _selectedRole = _firstRoleForCategory(_selectedCategory, _roles);
      }
    });
  }

  bool _matchesRoleFilter(FunctionalRole role) {
    switch (_roleFilter) {
      case 'system':
        return role.isActive && role.isImported;

      case 'custom':
        return role.isActive && !role.isImported;

      case 'inactive':
        return !role.isActive;

      default:
        return role.isActive;
    }
  }

  Future<void> _createRole() async {
    if (!_canCreateRole) return;

    final createdRole = await showDialog<FunctionalRole>(
      context: context,
      builder: (context) {
        return CreateFunctionalRoleDialog(
          organizationId: widget.organizationId,
          categories: _categories,
        );
      },
    );

    if (!mounted || createdRole == null) {
      return;
    }

    await _loadData();

    if (!mounted) return;

    final createdCategory = _categories
        .cast<FunctionalRoleCategory?>()
        .firstWhere(
          (category) => category?.id == createdRole.categoryId,
          orElse: () => null,
        );

    setState(() {
      if (createdCategory != null) {
        _selectedCategory = createdCategory;
      }

      final refreshedRole = _roles.cast<FunctionalRole?>().firstWhere(
        (role) => role?.id == createdRole.id,
        orElse: () => null,
      );

      if (refreshedRole != null && _matchesRoleFilter(refreshedRole)) {
        _selectedRole = refreshedRole;
      }
    });
  }

  Future<void> _handleRoleArchived() async {
    if (!mounted) return;

    setState(() {
      _selectedRole = null;
    });

    await _loadData();
  }

  Future<void> _handleRoleRestored() async {
    if (!mounted) return;

    setState(() {
      _selectedRole = null;
      _roleFilter = 'all';
    });

    await _loadData();
  }

  Future<void> _handleRoleDeleted() async {
    if (!mounted) return;

    setState(() {
      _selectedRole = null;
    });

    await _loadData();
  }

  @override
  void dispose() {
    _categorySearchController.dispose();
    _roleSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 40,
                color: Color(0xFF64748B),
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh_outlined),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final compactHeight = constraints.maxHeight < 650;

        if (compactHeight) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPageHeader(),
                const SizedBox(height: 16),
                SizedBox(
                  height: 600,
                  child: FunctionalRolesLayout(
                    organizationId: widget.organizationId,
                    categories: _categories,
                    roles: _roles,
                    selectedCategory: _selectedCategory,
                    selectedRole: _selectedRole,
                    roleFilter: _roleFilter,
                    categorySearchController: _categorySearchController,
                    roleSearchController: _roleSearchController,
                    onCategorySelected: _selectCategory,
                    onRoleSelected: _selectRole,
                    onRoleFilterChanged: _changeRoleFilter,
                    roleFilterMatcher: _matchesRoleFilter,
                    onRoleArchived: _handleRoleArchived,
                    onRoleRestored: _handleRoleRestored,
                    onRoleDeleted: _handleRoleDeleted,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: FunctionalRolesLayout(
                organizationId: widget.organizationId,
                categories: _categories,
                roles: _roles,
                selectedCategory: _selectedCategory,
                selectedRole: _selectedRole,
                roleFilter: _roleFilter,
                categorySearchController: _categorySearchController,
                roleSearchController: _roleSearchController,
                onCategorySelected: _selectCategory,
                onRoleSelected: _selectRole,
                onRoleFilterChanged: _changeRoleFilter,
                roleFilterMatcher: _matchesRoleFilter,
                onRoleArchived: _handleRoleArchived,
                onRoleRestored: _handleRoleRestored,
                onRoleDeleted: _handleRoleDeleted,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 800;

          if (compact) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0EBFF),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.people_alt_outlined,
                    color: Color(0xFF5B3FD3),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Functional Roles',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage the functional roles that define responsibilities across your organization.',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (_canCreateRole)
                  IconButton(
                    onPressed: _createRole,
                    tooltip: 'New Role',
                    icon: const Icon(Icons.add),
                  ),
              ],
            );
          }

          return Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EBFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.people_alt_outlined,
                  color: Color(0xFF5B3FD3),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Functional Roles',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage the functional roles that define responsibilities across your organization.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              if (_canCreateRole)
                FilledButton.icon(
                  onPressed: _createRole,
                  icon: const Icon(Icons.add),
                  label: const Text('New Role'),
                ),
            ],
          );
        },
      ),
    );
  }
}
