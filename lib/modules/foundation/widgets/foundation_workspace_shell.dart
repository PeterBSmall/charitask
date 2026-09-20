import 'package:flutter/material.dart';

import 'foundation_sidebar.dart';
import 'package:charitask/shared/widgets/navigation/ct_top_navigation.dart';
import 'package:charitask/modules/workspaces/templates/pages/workspace_template_selection_page.dart';
import 'package:charitask/modules/workspaces/templates/data/workspace_template_data.dart';

import 'package:charitask/shared/workspaces/models/ct_workspace.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/modules/workspaces/dashboard/pages/workspace_dashboard_page.dart';

class FoundationWorkspaceShell extends StatefulWidget {
  final Widget Function(ValueChanged<int> onNavigate) dashboardBuilder;
  final String firstName;
  final String organizationId;
  final VoidCallback? onPersonalHome;
  final Widget organization;
  final Widget people;
  final Widget locations;
  final Widget groups;
  final Widget security;
  final Widget analytics;
  final Widget notes;

  const FoundationWorkspaceShell({
    super.key,
    required this.dashboardBuilder,
    required this.firstName,
    required this.organizationId,
    this.onPersonalHome,
    required this.organization,
    required this.people,
    required this.locations,
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
  bool _isCustomizingDashboard = false;
  CTWorkspace? _activeWorkspace;

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
      _activeWorkspace = null;
      _isCustomizingDashboard = false;
    });
  }

  void _handleWorkspaceSelected(Map<String, dynamic> workspace) {
    final workspaceId = workspace['id'] as String?;
    final workspaceName = workspace['name'] as String?;

    if (workspaceId == null || workspaceName == null) {
      return;
    }

    debugPrint('>>> SWITCHING TO ORGANIZATION WORKSPACE: $workspaceName');
    debugPrint('>>> WORKSPACE ID: $workspaceId');

    setState(() {
      _selectedIndex = 0;
      _isCustomizingDashboard = false;
      _activeWorkspace = CTWorkspace(
        id: workspaceId,
        name: workspaceName,
        type: CTWorkspaceType.organization,
        icon: Icons.workspaces_rounded,
        color: const Color(0xFF5B4BC4),
        templateId: workspace['template_id'] as String?,
      );
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

  void _toggleDashboardCustomization() {
    setState(() {
      _isCustomizingDashboard = !_isCustomizingDashboard;
    });
  }

  Future<void> _finishWorkspaceCreation(String templateId) async {
    final allTemplates = [
      ...missionCommunityTemplates,
      ...fundraisingProgramsTemplates,
      ...peopleResourcesComplianceTemplates,
      ...creativeFlexibleTemplates,
    ];

    final template = allTemplates.firstWhere((item) => item.id == templateId);

    try {
      debugPrint('>>> CREATING ORGANIZATION WORKSPACE: ${template.title}');

      final supabase = Supabase.instance.client;

      final result = await supabase.rpc(
        'create_organization_workspace',
        params: {
          'p_name': template.title,
          'p_description': null,
          'p_template_id': template.id,
        },
      );

      final data = Map<String, dynamic>.from(result as Map);

      final workspace = CTWorkspace(
        id: data['workspace_id'] as String,
        name: data['name'] as String,
        type: CTWorkspaceType.organization,
        icon: template.icon,
        color: template.accentColor,
        templateId: data['template_id'] as String?,
      );

      debugPrint('>>> CREATED ORGANIZATION WORKSPACE: ${workspace.name}');
      debugPrint('>>> WORKSPACE ID: ${workspace.id}');
      debugPrint('>>> TEMPLATE ID: ${workspace.templateId}');

      if (!mounted) return;

      setState(() {
        _activeWorkspace = workspace;
        _isCreatingWorkspace = false;
      });
    } catch (error, stackTrace) {
      debugPrint('>>> CREATE ORGANIZATION WORKSPACE FAILED: $error');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _isCreatingWorkspace = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to create workspace: $error')),
      );
    }
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
      return WorkspaceDashboardPage(
        key: ValueKey(_activeWorkspace!.id),
        workspace: _activeWorkspace!,
        firstName: widget.firstName,
        isCustomizing: _isCustomizingDashboard,
        onToggleCustomization: _toggleDashboardCustomization,
      );
    }

    switch (_selectedIndex) {
      case 0:
        return widget.dashboardBuilder(_navigateTo);

      case 1:
        return widget.organization;

      case 2:
        return widget.people;

      case 3:
        return widget.locations;

      case 4:
        return widget.groups;

      case 5:
        return widget.security;

      case 6:
        return widget.analytics;

      case 7:
        return widget.notes;

      case 8:
        return const SizedBox.shrink();

      default:
        return widget.dashboardBuilder(_navigateTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          FoundationSidebar(
            selectedIndex: _selectedIndex,
            isCollapsed: _isSidebarCollapsed,
            onSelected: _navigateTo,
            onToggleCollapse: _toggleSidebar,
            onCreateWorkspace: _createWorkspace,
            onPersonalHome: widget.onPersonalHome,
            organizationId: widget.organizationId,
            onWorkspaceSelected: _handleWorkspaceSelected,
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
                  onCustomize: _toggleDashboardCustomization,
                  isCustomizing: _isCustomizingDashboard,
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
