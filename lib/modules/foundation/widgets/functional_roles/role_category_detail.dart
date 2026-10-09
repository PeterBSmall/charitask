import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/domain/models/functional_role.dart';
import 'package:charitask/modules/foundation/domain/models/functional_role_category.dart';

import 'role_category_roles.dart';
import 'role_category_settings.dart';
import 'role_category_tabs.dart';
import 'functional_role_category_icon.dart';

class RoleCategoryDetail extends StatefulWidget {
  final FunctionalRoleCategory? category;
  final List<FunctionalRole> roles;
  final int roleCount;
  final int assignmentCount;
  final ValueChanged<FunctionalRole>? onRoleSelected;

  const RoleCategoryDetail({
    super.key,
    required this.category,
    required this.roles,
    required this.roleCount,
    required this.assignmentCount,
    this.onRoleSelected,
  });

  @override
  State<RoleCategoryDetail> createState() => _RoleCategoryDetailState();
}

class _RoleCategoryDetailState extends State<RoleCategoryDetail> {
  int _selectedTab = 0;
  String? _selectedRoleId;

  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _purple = Color(0xFF5B3FD3);

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    if (category == null) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: const Center(
          child: Text(
            'Select a category to view its details.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: _muted),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(category),
          const SizedBox(height: 22),
          RoleCategoryTabs(
            selectedIndex: _selectedTab,
            roleCount: widget.roleCount,
            onChanged: (index) {
              setState(() {
                _selectedTab = index;
              });
            },
          ),
          const SizedBox(height: 22),
          _buildTabContent(category),
        ],
      ),
    );
  }

  Widget _buildHeader(FunctionalRoleCategory category) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF0EBFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            FunctionalRoleCategoryIcon.forSlug(category.slug),
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
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category.slug,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: _muted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _StatusBadge(isActive: category.isActive),
      ],
    );
  }

  Widget _buildTabContent(FunctionalRoleCategory category) {
    switch (_selectedTab) {
      case 0:
        return RoleCategoryRoles(
          roles: widget.roles,
          selectedRoleId: _selectedRoleId,
          onRoleSelected: (roleId) {
            setState(() {
              _selectedRoleId = roleId;
            });

            for (final role in widget.roles) {
              if (role.id == roleId) {
                widget.onRoleSelected?.call(role);
                break;
              }
            }
          },
        );
      case 2:
        return RoleCategorySettings(category: category);

      default:
        return _buildOverview(category);
    }
  }

  Widget _buildOverview(FunctionalRoleCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _muted,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.description?.trim().isNotEmpty == true
              ? category.description!
              : 'No description has been added for this category.',
          style: const TextStyle(fontSize: 14, height: 1.5, color: _text),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Metric(
              icon: Icons.work_outline,
              value: widget.roleCount,
              label: 'Roles',
            ),
            _Metric(
              icon: Icons.people_outline,
              value: widget.assignmentCount,
              label: 'Assignments',
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isActive ? const Color(0xFF047857) : const Color(0xFF64748B),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _Metric({required this.icon, required this.value, required this.label});

  static const _text = Color(0xFF1E293B);
  static const _muted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: _muted),
          const SizedBox(width: 8),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _text,
            ),
          ),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12, color: _muted)),
        ],
      ),
    );
  }
}
