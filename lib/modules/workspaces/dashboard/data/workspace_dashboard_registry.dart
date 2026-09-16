import '../models/workspace_dashboard_config.dart';
import '../models/workspace_dashboard_module.dart';
import 'volunteer_coordinator_dashboard.dart';
import 'workspace_dashboard_defaults.dart';

class WorkspaceDashboardDefinition {
  final WorkspaceDashboardConfig config;
  final List<WorkspaceDashboardModule> modules;

  const WorkspaceDashboardDefinition({
    required this.config,
    required this.modules,
  });
}

/// Dashboard definitions by Personal Workspace template.
///
/// Only templates that have actually been implemented belong here.
/// At this point, Volunteer Coordinator is the only implemented template.
const Map<String, WorkspaceDashboardDefinition> workspaceDashboardRegistry = {
  'volunteer_coordinator': WorkspaceDashboardDefinition(
    config: volunteerCoordinatorDashboardConfig,
    modules: volunteerCoordinatorDashboardModules,
  ),
};

WorkspaceDashboardDefinition? getWorkspaceDashboardDefinition(
  String? templateId,
) {
  if (templateId == null) {
    return null;
  }

  return workspaceDashboardRegistry[templateId];
}
