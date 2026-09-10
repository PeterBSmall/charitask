import 'package:flutter/material.dart';

import 'foundation_sidebar.dart';

import 'package:charitask/shared/widgets/navigation/ct_top_navigation.dart';

import 'package:charitask/modules/workspaces/templates/pages/workspace_template_selection_page.dart';
import 'package:charitask/modules/workspaces/templates/data/workspace_template_data.dart';

import 'package:charitask/shared/workspaces/models/ct_workspace.dart';
import 'package:charitask/shared/workspaces/services/ct_workspace_service.dart';

import 'package:charitask/modules/workspaces/dashboard/pages/workspace_dashboard_page.dart';

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
  bool _isCreatingWorkspace = false;

  CTWorkspace? _activeWorkspace;

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
      _activeWorkspace = null;
    });
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
  }

  void _createWorkspace() {
    setState(() {
      _isCreatingWorkspace = true;
    });
  }

  void _finishWorkspaceCreation(String templateId) {
    final allTemplates = [
      ...missionCommunityTemplates,
      ...fundraisingProgramsTemplates,
      ...peopleResourcesComplianceTemplates,
      ...creativeFlexibleTemplates,
    ];

    final template = allTemplates.firstWhere((item) => item.id == templateId);

    final workspace = CTWorkspaceService.createWorkspace(
      id: template.id,
      name: template.title,
      type: CTWorkspaceType.team,
      icon: template.icon,
      color: template.accentColor,
    );

    debugPrint('>>> CREATED WORKSPACE: ${workspace.name}');

    setState(() {
      _activeWorkspace = workspace;
      _isCreatingWorkspace = false;
    });
  }

  Widget get _currentPage {
    if (_isCreatingWorkspace) {
      return WorkspaceTemplateSelectionPage(
        onBack: () {
          setState(() {
            _isCreatingWorkspace = false;
          });
        },
        onContinue: _finishWorkspaceCreation,
      );
    }

    if (_activeWorkspace != null) {
      return WorkspaceDashboardPage(workspace: _activeWorkspace!);
    }

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
              onCreateWorkspace: _createWorkspace,
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
