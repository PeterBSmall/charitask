import 'package:flutter/material.dart';

import 'package:charitask/modules/workspaces/dashboard/pages/workspace_dashboard_page.dart';
import 'package:charitask/shared/widgets/navigation/ct_top_navigation.dart';
import 'package:charitask/shared/widgets/navigation/personal_workspace_sidebar.dart';
import 'package:charitask/shared/workspaces/models/ct_workspace.dart';

class PersonalWorkspaceShell extends StatefulWidget {
  final CTWorkspace workspace;
  final String firstName;

  const PersonalWorkspaceShell({
    super.key,
    required this.workspace,
    required this.firstName,
  });

  @override
  State<PersonalWorkspaceShell> createState() => _PersonalWorkspaceShellState();
}

class _PersonalWorkspaceShellState extends State<PersonalWorkspaceShell> {
  bool _isSidebarCollapsed = false;
  bool _isCustomizingDashboard = false;

  String _selectedSidebarItem = 'Overview';

  int _topNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Row(
        children: [
          PersonalWorkspaceSidebar(
            workspaceName: widget.workspace.name,
            selectedItem: _selectedSidebarItem,
            isCollapsed: _isSidebarCollapsed,
            onToggleCollapse: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
            items: [
              PersonalWorkspaceSidebarItem(
                label: 'Overview',
                icon: Icons.grid_view_rounded,
                onTap: () {
                  setState(() {
                    _selectedSidebarItem = 'Overview';
                  });
                },
              ),
              PersonalWorkspaceSidebarItem(
                label: 'Tasks',
                icon: Icons.check_circle_outline_rounded,
                onTap: () {
                  setState(() {
                    _selectedSidebarItem = 'Tasks';
                  });
                },
              ),
              PersonalWorkspaceSidebarItem(
                label: 'Activity',
                icon: Icons.history_rounded,
                onTap: () {
                  setState(() {
                    _selectedSidebarItem = 'Activity';
                  });
                },
              ),
              PersonalWorkspaceSidebarItem(
                label: 'Notes',
                icon: Icons.sticky_note_2_outlined,
                onTap: () {
                  setState(() {
                    _selectedSidebarItem = 'Notes';
                  });
                },
              ),
              PersonalWorkspaceSidebarItem(
                label: 'Settings',
                icon: Icons.settings_outlined,
                onTap: () {
                  setState(() {
                    _selectedSidebarItem = 'Settings';
                  });
                },
              ),
            ],
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
                  onCustomize: () {
                    setState(() {
                      _isCustomizingDashboard = !_isCustomizingDashboard;
                    });
                  },
                  isCustomizing: _isCustomizingDashboard,
                ),

                Expanded(
                  child: WorkspaceDashboardPage(
                    workspace: widget.workspace,
                    firstName: widget.firstName,
                    isCustomizing: _isCustomizingDashboard,
                    onToggleCustomization: () {
                      setState(() {
                        _isCustomizingDashboard = !_isCustomizingDashboard;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
