import '../models/workspace_dashboard_module.dart';

const volunteerCoordinatorDashboardModules = [
  WorkspaceDashboardModule(
    id: 'hero',
    type: WorkspaceDashboardModuleType.hero,
    title: 'Workspace Hero',
    visible: true,
    position: 0,
    isMovable: false,
  ),

  WorkspaceDashboardModule(
    id: 'inspiration',
    type: WorkspaceDashboardModuleType.inspiration,
    title: 'Together',
    visible: true,
    position: 1,
    isMovable: false,
  ),

  WorkspaceDashboardModule(
    id: 'kpis',
    type: WorkspaceDashboardModuleType.kpis,
    title: 'Key Metrics',
    visible: true,
    position: 2,
    isMovable: false,
  ),

  WorkspaceDashboardModule(
    id: 'essentials',
    type: WorkspaceDashboardModuleType.essentials,
    title: 'The Essentials',
    visible: true,
    position: 3,
    isMovable: true,
  ),

  WorkspaceDashboardModule(
    id: 'at_a_glance',
    type: WorkspaceDashboardModuleType.atAGlance,
    title: 'Workspace At a Glance',
    visible: true,
    position: 4,
    isMovable: true,
  ),

  WorkspaceDashboardModule(
    id: 'health',
    type: WorkspaceDashboardModuleType.health,
    title: 'Workspace Health',
    visible: true,
    position: 5,
    isMovable: true,
  ),

  WorkspaceDashboardModule(
    id: 'activity',
    type: WorkspaceDashboardModuleType.activity,
    title: 'Recent Activity',
    visible: true,
    position: 6,
    isMovable: true,
  ),

  WorkspaceDashboardModule(
    id: 'messaging',
    type: WorkspaceDashboardModuleType.messaging,
    title: 'Internal Messaging',
    visible: true,
    position: 7,
    isMovable: true,
  ),
];
