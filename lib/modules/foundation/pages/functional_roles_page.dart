import 'package:flutter/material.dart';
import 'role_categories_page.dart';

class FunctionalRolesPage extends StatefulWidget {
  final String organizationId;

  const FunctionalRolesPage({super.key, required this.organizationId});

  @override
  State<FunctionalRolesPage> createState() => _FunctionalRolesPageState();
}

class _FunctionalRolesPageState extends State<FunctionalRolesPage> {
  int _selectedSection = 0;

  static const _sections = [
    'Role Categories',
    'Roles',
    'Permissions',
    'Role Assignments',
  ];

  static const _sectionIcons = [
    Icons.category_outlined,
    Icons.badge_outlined,
    Icons.lock_outline,
    Icons.assignment_ind_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(constraints),
              const SizedBox(height: 24),
              _buildNavigation(constraints),
              const SizedBox(height: 24),
              _buildContent(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BoxConstraints constraints) {
    final compact = constraints.maxWidth < 700;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 20 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildTitle()],
            )
          : Row(children: [Expanded(child: _buildTitle())]),
    );
  }

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Functional Roles',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Manage the functional roles that define responsibilities across your organization.',
          style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildNavigation(BoxConstraints constraints) {
    final compact = constraints.maxWidth < 800;

    if (compact) {
      return _buildCompactNavigation();
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: List.generate(
          _sections.length,
          (index) => Expanded(child: _buildNavigationItem(index)),
        ),
      ),
    );
  }

  Widget _buildCompactNavigation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(
          _sections.length,
          (index) => _buildNavigationItem(index, compact: true),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(int index, {bool compact = false}) {
    final selected = _selectedSection == index;

    return Material(
      color: selected ? const Color(0xFF5B3FD3) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _selectedSection = index;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 14 : 16,
            vertical: 12,
          ),
          child: Row(
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _sectionIcons[index],
                size: 18,
                color: selected ? Colors.white : const Color(0xFF64748B),
              ),
              const SizedBox(width: 8),
              Text(
                _sections[index],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedSection) {
      case 0:
        return RoleCategoriesPage(organizationId: widget.organizationId);

      default:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            _sections[_selectedSection],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        );
    }
  }
}
