import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/workspaces/foundation_modules.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_tasks.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_metrics_data.dart';
import 'package:charitask/modules/foundation/widgets/foundation_activity.dart';
import 'package:charitask/modules/foundation/widgets/foundation_hero.dart';

import 'package:charitask/shared/widgets/layout/ct_page.dart';
import 'package:charitask/shared/widgets/workspace/ct_workspace_metrics.dart';
import 'package:charitask/shared/widgets/workspace/ct_workspace_modules.dart';
import 'package:charitask/shared/widgets/workspace/ct_workspace_tasks.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/design_system.dart';

class FoundationWorkspacePage extends StatefulWidget {
  final CTJourneyController journeyController;

  const FoundationWorkspacePage({super.key, required this.journeyController});

  @override
  State<FoundationWorkspacePage> createState() =>
      _FoundationWorkspacePageState();
}

class _FoundationWorkspacePageState extends State<FoundationWorkspacePage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CTPage(
      title: 'Foundation',
      subtitle: 'Build the structure that supports your organization.',
      child: AppScrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FoundationHero(journeyController: widget.journeyController),

              const SizedBox(height: AppSpacing.lg),

              CTWorkspaceMetrics(metrics: foundationMetrics),

              const SizedBox(height: AppSpacing.lg),

              CTWorkspaceTasks(tasks: foundationTasks),

              const SizedBox(height: AppSpacing.lg),

              CTWorkspaceModules(
                title: 'Foundation Modules',
                modules: foundationModules,
              ),

              const SizedBox(height: AppSpacing.lg),

              FoundationActivity(),
            ],
          ),
        ),
      ),
    );
  }
}
