import 'package:flutter/material.dart';

import '../../../../domain/models/functional_role.dart';
import '../../../../domain/models/functional_role_category.dart';
import 'role_settings_widgets.dart';

class RoleSettingsCategory extends StatelessWidget {
  final FunctionalRole role;
  final List<FunctionalRoleCategory> categories;
  final String? selectedCategoryId;
  final bool canManage;
  final bool saving;
  final bool loading;
  final ValueChanged<String?> onChanged;

  const RoleSettingsCategory({
    super.key,
    required this.role,
    required this.categories,
    required this.selectedCategoryId,
    required this.canManage,
    required this.saving,
    required this.loading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSystemRole = role.isImported;

    return RoleSettingsCard(
      title: 'Role Category',
      subtitle: isSystemRole
          ? 'Category assigned by ChariTask.'
          : 'Choose the category where this role belongs.',
      child: _buildContent(isSystemRole),
    );
  }

  Widget _buildContent(bool isSystemRole) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: CircularProgressIndicator(),
      );
    }

    if (categories.isEmpty) {
      return const Text(
        'No active role categories are available.',
        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
      );
    }

    final validCategoryId =
        categories.any((category) => category.id == selectedCategoryId)
        ? selectedCategoryId
        : null;

    final selectedCategory = categories
        .cast<FunctionalRoleCategory?>()
        .firstWhere(
          (category) => category?.id == validCategoryId,
          orElse: () => null,
        );

    if (isSystemRole) {
      return Row(
        children: [
          const Icon(Icons.folder_outlined, size: 19, color: Color(0xFF64748B)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              selectedCategory?.name ?? role.categoryName ?? 'Uncategorized',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          const Icon(Icons.lock_outline, size: 18, color: Color(0xFF94A3B8)),
        ],
      );
    }

    return DropdownButtonFormField<String>(
      key: ValueKey(validCategoryId),
      initialValue: validCategoryId,
      isExpanded: true,
      decoration: roleSettingsInputDecoration(hintText: 'Select a category'),
      items: categories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.name),
            ),
          )
          .toList(),
      onChanged: canManage && !saving ? onChanged : null,
    );
  }
}
