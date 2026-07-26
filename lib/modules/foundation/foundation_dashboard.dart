import 'package:charitask/modules/foundation/widgets/foundation_activity.dart';
import 'package:charitask/modules/foundation/widgets/foundation_hero.dart';
import 'package:charitask/modules/foundation/widgets/foundation_metrics.dart';
import 'package:charitask/modules/foundation/widgets/foundation_modules.dart';
import 'package:charitask/modules/foundation/widgets/foundation_quick_actions.dart';

import 'package:charitask/shared/models/ct_suite_dashboard_config.dart';

const foundationDashboard = CTSuiteDashboardConfig(
  hero: FoundationHero(),
  metrics: FoundationMetrics(),
  quickActions: FoundationQuickActions(),
  modules: FoundationModules(),
  activity: FoundationActivity(),

  modulesTitle: 'Explore Foundation',
  modulesSubtitle: 'Configure your organization and core settings.',
);
