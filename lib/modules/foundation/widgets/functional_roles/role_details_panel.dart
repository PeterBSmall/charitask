import 'package:flutter/material.dart';

import '../../domain/models/functional_role.dart';
import '../../domain/models/functional_role_category.dart';
import 'role_details/role_details_assignments.dart';
import 'role_details/role_details_header.dart';
import 'role_details/role_details_overview.dart';
import 'role_details/role_details_people.dart';
import 'role_details/role_details_permissions.dart';
import 'role_details/role_details_settings.dart';

class RoleDetailsPanel extends StatefulWidget {
  final String organizationId;
  final FunctionalRoleCategory category;
  final FunctionalRole role;

  final VoidCallback? onRoleArchived;
  final VoidCallback? onRoleRestored;
  final VoidCallback? onRoleDeleted;

  const RoleDetailsPanel({
    super.key,
    required this.organizationId,
    required this.category,
    required this.role,
    this.onRoleArchived,
    this.onRoleRestored,
    this.onRoleDeleted,
  });

  @override
  State<RoleDetailsPanel> createState() => _RoleDetailsPanelState();
}

class _RoleDetailsPanelState extends State<RoleDetailsPanel> {
  static const _tabs = [
    'Overview',
    'Permissions',
    'Members',
    'Assignments',
    'Settings',
  ];

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RoleDetailsHeader(category: widget.category, role: widget.role),
            const SizedBox(height: 16),
            _buildTabs(),
            const SizedBox(height: 20),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(_tabs.length, _buildTabButton),
            );
          }

          return Row(
            children: List.generate(
              _tabs.length,
              (index) => Expanded(child: _buildTabButton(index)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton(int index) {
    final selected = _selectedTab == index;

    final label = index == 3
        ? 'Assignments (${widget.role.assignmentCount})'
        : _tabs[index];

    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
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

  Widget _buildContent() {
    switch (_selectedTab) {
      case 1:
        return RoleDetailsPermissions(
          organizationId: widget.organizationId,
          role: widget.role,
        );

      case 2:
        return RoleDetailsPeople(
          organizationId: widget.organizationId,
          role: widget.role,
        );

      case 3:
        return RoleDetailsAssignments(
          organizationId: widget.organizationId,
          role: widget.role,
        );

      case 4:
        return RoleDetailsSettings(
          organizationId: widget.organizationId,
          role: widget.role,
          onRoleArchived: widget.onRoleArchived,
          onRoleRestored: widget.onRoleRestored,
          onRoleDeleted: widget.onRoleDeleted,
        );

      default:
        return RoleDetailsOverview(
          category: widget.category,
          role: widget.role,
        );
    }
  }
}
