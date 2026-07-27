import 'package:charitask/modules/foundation/pages/workspaces/foundation_modules.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_tasks.dart';
import 'package:charitask/modules/foundation/widgets/foundation_activity.dart';
import 'package:charitask/modules/foundation/widgets/foundation_hero.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_metrics_data.dart';

import 'package:charitask/shared/widgets/workspace/ct_workspace_metrics.dart';

import 'package:charitask/shared/models/ct_suite_dashboard_config.dart';
import 'package:charitask/shared/widgets/workspace/ct_workspace_modules.dart';
import 'package:charitask/shared/widgets/workspace/ct_workspace_tasks.dart';

const foundationDashboard = CTSuiteDashboardConfig(
  hero: FoundationHero(),
  metrics: CTWorkspaceMetrics(metrics: foundationMetrics),

  primaryContent: CTWorkspaceTasks(tasks: foundationTasks),

  secondaryContent: CTWorkspaceModules(
    title: 'Foundation Modules',
    modules: foundationModules,
  ),

  activity: FoundationActivity(),

  primaryTitle: 'Active Tasks',
  primarySubtitle: 'Continue building your organization.',

  secondaryTitle: 'Foundation Modules',
  secondarySubtitle: 'Configure your organization and core settings.',
);
