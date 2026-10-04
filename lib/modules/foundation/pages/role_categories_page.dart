import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/data/services/functional_role_service.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role_category.dart';
import '../widgets/functional_roles/role_category_detail.dart';
import '../widgets/functional_roles/role_categories_header.dart';
import '../widgets/functional_roles/role_categories_list.dart';
import '../widgets/functional_roles/role_categories_toolbar.dart';

class RoleCategoriesPage extends StatefulWidget {
  final String organizationId;

  const RoleCategoriesPage({super.key, required this.organizationId});

  @override
  State<RoleCategoriesPage> createState() => _RoleCategoriesPageState();
}

class _RoleCategoriesPageState extends State<RoleCategoriesPage> {
  final FunctionalRoleService _service = FunctionalRoleService();

  List<FunctionalRoleCategory> _categories = [];
  List<FunctionalRole> _roles = [];

  String? _selectedCategoryId;
  String _searchQuery = '';

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final categories = await _service.getCategories(
        organizationId: widget.organizationId,
      );
      debugPrint(
        'ROLE CATEGORY ORDER: ${categories.map((category) => category.name).join(' | ')}',
      );
      final roles = await _service.getRoles(
        organizationId: widget.organizationId,
      );

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _roles = roles;
        _loading = false;

        if (_selectedCategoryId == null ||
            !categories.any((category) => category.id == _selectedCategoryId)) {
          _selectedCategoryId = categories.isEmpty ? null : categories.first.id;
        }
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  List<FunctionalRoleCategory> get _filteredCategories {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return _categories;
    }

    return _categories.where((category) {
      final name = category.name.toLowerCase();
      final description = category.description?.toLowerCase() ?? '';
      final slug = category.slug.toLowerCase();

      return name.contains(query) ||
          description.contains(query) ||
          slug.contains(query);
    }).toList();
  }

  FunctionalRoleCategory? get _selectedCategory {
    for (final category in _categories) {
      if (category.id == _selectedCategoryId) {
        return category;
      }
    }

    return null;
  }

  Map<String, int> get _roleCounts {
    final counts = <String, int>{};

    for (final role in _roles) {
      final categoryId = role.categoryId;

      if (categoryId == null) {
        continue;
      }

      counts[categoryId] = (counts[categoryId] ?? 0) + 1;
    }

    return counts;
  }

  Map<String, int> get _assignmentCounts {
    final counts = <String, int>{};

    for (final role in _roles) {
      final categoryId = role.categoryId;

      if (categoryId == null) {
        continue;
      }

      counts[categoryId] = (counts[categoryId] ?? 0) + role.assignmentCount;
    }

    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;

        return SingleChildScrollView(
          padding: EdgeInsets.all(compact ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoleCategoriesHeader(compact: compact),
              const SizedBox(height: 20),
              RoleCategoriesToolbar(
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onRefresh: _loadData,
                loading: _loading,
              ),
              const SizedBox(height: 20),
              if (_error != null) _buildError(),
              if (_error == null) _buildCategoryContent(compact: compact),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryContent({required bool compact}) {
    final categories = _filteredCategories;

    final content = compact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoleCategoriesList(
                categories: categories,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: _selectCategory,
                roleCounts: _roleCounts,
                assignmentCounts: _assignmentCounts,
              ),
              const SizedBox(height: 16),
              RoleCategoryDetail(
                category: _selectedCategory,
                roles: _roles
                    .where((role) => role.categoryId == _selectedCategoryId)
                    .toList(),
                roleCount: _roleCounts[_selectedCategoryId] ?? 0,
                assignmentCount: _assignmentCounts[_selectedCategoryId] ?? 0,
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: RoleCategoriesList(
                  categories: categories,
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: _selectCategory,
                  roleCounts: _roleCounts,
                  assignmentCounts: _assignmentCounts,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: RoleCategoryDetail(
                  category: _selectedCategory,
                  roles: _roles
                      .where((role) => role.categoryId == _selectedCategoryId)
                      .toList(),
                  roleCount: _roleCounts[_selectedCategoryId] ?? 0,
                  assignmentCount: _assignmentCounts[_selectedCategoryId] ?? 0,
                ),
              ),
            ],
          );

    return content;
  }

  Widget _buildError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFB91C1C)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF991B1B)),
            ),
          ),
        ],
      ),
    );
  }

  void _selectCategory(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }
}
