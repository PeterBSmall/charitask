import 'package:flutter/material.dart';

import 'foundation_sidebar.dart';
import 'package:charitask/shared/widgets/navigation/ct_top_navigation.dart';

class FoundationWorkspaceShell extends StatefulWidget {
  final Widget Function(ValueChanged<int> onNavigate) dashboardBuilder;
  final Widget organization;
  final Widget people;
  final Widget groups;
  final Widget security;
  final Widget analytics;
  final Widget notes;

  const FoundationWorkspaceShell({
    super.key,
    required this.dashboardBuilder,
    required this.organization,
    required this.people,
    required this.groups,
    required this.security,
    required this.analytics,
    required this.notes,
  });

  @override
  State<FoundationWorkspaceShell> createState() =>
      _FoundationWorkspaceShellState();
}

class _FoundationWorkspaceShellState extends State<FoundationWorkspaceShell> {
  int _selectedIndex = 0;
  int _topNavIndex = 0;

  bool _isSidebarCollapsed = false;

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
  }

  Widget get _currentPage {
    switch (_selectedIndex) {
      case 0:
        return widget.dashboardBuilder(_navigateTo);

      case 1:
        return widget.organization;

      case 2:
        return widget.people;

      case 3:
        return widget.groups;

      case 4:
        return widget.security;

      case 5:
        return widget.analytics;

      case 6:
        return widget.notes;

      default:
        return widget.dashboardBuilder(_navigateTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: _isSidebarCollapsed ? 72 : 260,
            child: FoundationSidebar(
              selectedIndex: _selectedIndex,
              onSelected: _navigateTo,
              isCollapsed: _isSidebarCollapsed,
              onToggleCollapse: _toggleSidebar,
            ),
          ),

          Expanded(
            child: Column(
              children: [
                CTTopNavigation(
                  selectedIndex: _topNavIndex,
                  onSelected: (index) {
                    setState(() {
                      _topNavIndex = index;
                    });
                  },
                ),

                Expanded(child: _currentPage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
