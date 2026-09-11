import 'package:flutter/material.dart';

import 'package:charitask/shared/workspaces/models/ct_workspace.dart';

import '../controllers/workspace_dashboard_layout_controller.dart';
import '../data/volunteer_coordinator_dashboard.dart';
import '../models/workspace_dashboard_config.dart';

import '../widgets/workspace_dashboard_hero.dart';
import '../widgets/workspace_inspiration_card.dart';
import '../widgets/workspace_kpi_row.dart';
import '../widgets/workspace_essentials.dart';
import '../widgets/workspace_at_a_glance.dart';
import '../widgets/workspace_health_card.dart';
import '../widgets/workspace_activity.dart';
import '../widgets/workspace_messaging.dart';
import '../widgets/workspace_dashboard_customization_bar.dart';
import '../widgets/workspace_dashboard_editable.dart';
import '../widgets/workspace_dashboard_drop_target.dart';
import '../data/workspace_dashboard_defaults.dart';

class WorkspaceDashboardPage extends StatefulWidget {
  final CTWorkspace workspace;
  final String firstName;
  final bool isCustomizing;
  final VoidCallback onToggleCustomization;

  const WorkspaceDashboardPage({
    super.key,
    required this.workspace,
    required this.firstName,
    required this.isCustomizing,
    required this.onToggleCustomization,
  });

  @override
  State<WorkspaceDashboardPage> createState() => _WorkspaceDashboardPageState();
}

class _WorkspaceDashboardPageState extends State<WorkspaceDashboardPage> {
  late final WorkspaceDashboardLayoutController _layoutController;

  String? _draggingModuleId;
  List<String> _rightColumnOrder = ['health', 'activity', 'messaging'];

  @override
  void initState() {
    super.initState();

    _layoutController = WorkspaceDashboardLayoutController(
      modules: volunteerCoordinatorDashboardModules,
    );
  }

  // ============================================================
  // DRAG / DROP
  // ============================================================

  void _startDragging(String moduleId) {
    setState(() {
      _draggingModuleId = moduleId;
    });
  }

  void _stopDragging() {
    if (_draggingModuleId == null) {
      return;
    }

    setState(() {
      _draggingModuleId = null;
    });
  }

  void _dropOnModule(String targetModuleId) {
    final draggingModuleId = _draggingModuleId;

    if (draggingModuleId == null || draggingModuleId == targetModuleId) {
      _stopDragging();
      return;
    }

    final target = _layoutController.findModule(targetModuleId);

    if (target == null || !target.isMovable) {
      _stopDragging();
      return;
    }

    final targetPosition = target.position;

    _layoutController.moveModule(
      moduleId: draggingModuleId,
      newPosition: targetPosition,
    );

    setState(() {
      _draggingModuleId = null;
    });
  }

  void _startRightColumnDragging(String moduleId) {
    setState(() {
      _draggingModuleId = moduleId;
    });
  }

  void _dropOnRightColumnModule(String targetModuleId) {
    final draggingModuleId = _draggingModuleId;

    if (draggingModuleId == null || draggingModuleId == targetModuleId) {
      _stopDragging();
      return;
    }

    final draggingIndex = _rightColumnOrder.indexOf(draggingModuleId);
    final targetIndex = _rightColumnOrder.indexOf(targetModuleId);

    if (draggingIndex == -1 || targetIndex == -1) {
      _stopDragging();
      return;
    }

    final updatedOrder = List<String>.from(_rightColumnOrder);

    final draggedModule = updatedOrder.removeAt(draggingIndex);

    updatedOrder.insert(targetIndex, draggedModule);

    setState(() {
      _rightColumnOrder = updatedOrder;
      _draggingModuleId = null;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final config = volunteerCoordinatorDashboardConfig;

    return Container(
      color: const Color(0xFFF7F8FC),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 1000;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              isCompact ? 16 : 28,
              14,
              isCompact ? 16 : 28,
              28,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.isCustomizing)
                      WorkspaceDashboardCustomizationBar(
                        onDone: widget.onToggleCustomization,
                      ),
                    isCompact
                        ? _buildCompactLayout(config)
                        : _buildDesktopLayout(config),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktopLayout(WorkspaceDashboardConfig config) {
    final essentialsPosition =
        _layoutController.findModule('essentials')?.position ?? 999;

    final glancePosition =
        _layoutController.findModule('at_a_glance')?.position ?? 999;

    final essentialsFirst = essentialsPosition <= glancePosition;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======================================================
        // LEFT / MAIN COLUMN
        // ======================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HERO — ANCHORED
              if (_layoutController.isVisible('hero'))
                WorkspaceDashboardHero(
                  config: config,
                  firstName: widget.firstName,
                ),

              if (_layoutController.isVisible('hero'))
                const SizedBox(height: 16),

              // KPIs — ANCHORED
              if (_layoutController.isVisible('kpis'))
                WorkspaceKpiRow(config: config),

              if (_layoutController.isVisible('kpis'))
                const SizedBox(height: 20),

              // MOVABLE MODULES
              if (essentialsFirst) ...[
                if (_layoutController.isVisible('essentials'))
                  _buildEssentials(config),

                if (_layoutController.isVisible('essentials'))
                  const SizedBox(height: 16),

                if (_layoutController.isVisible('at_a_glance'))
                  _buildAtAGlance(config),
              ] else ...[
                if (_layoutController.isVisible('at_a_glance'))
                  _buildAtAGlance(config),

                if (_layoutController.isVisible('at_a_glance'))
                  const SizedBox(height: 16),

                if (_layoutController.isVisible('essentials'))
                  _buildEssentials(config),
              ],
            ],
          ),
        ),

        const SizedBox(width: 20),

        // ======================================================
        // RIGHT COLUMN
        // ======================================================
        SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_layoutController.isVisible('inspiration'))
                WorkspaceInspirationCard(config: config),

              if (_layoutController.isVisible('inspiration'))
                const SizedBox(height: 16),

              for (var i = 0; i < _rightColumnOrder.length; i++) ...[
                if (_layoutController.isVisible(_rightColumnOrder[i]))
                  _buildRightColumnModule(_rightColumnOrder[i], config),

                if (i < _rightColumnOrder.length - 1)
                  const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ESSENTIALS
  // ============================================================

  Widget _buildEssentials(WorkspaceDashboardConfig config) {
    return WorkspaceDashboardDropTarget(
      moduleId: 'essentials',
      onDrop: _dropOnModule,
      child: WorkspaceDashboardEditable(
        moduleId: 'essentials',
        isCustomizing: widget.isCustomizing,
        handlePosition: WorkspaceDashboardHandlePosition.topRight,
        onDragStarted: () {
          _startDragging('essentials');
        },
        onDragEnd: _stopDragging,
        child: WorkspaceEssentials(accentColor: config.accentColor),
      ),
    );
  }

  // ============================================================
  // AT A GLANCE
  // ============================================================

  Widget _buildAtAGlance(WorkspaceDashboardConfig config) {
    return WorkspaceDashboardDropTarget(
      moduleId: 'at_a_glance',
      onDrop: _dropOnModule,
      child: WorkspaceDashboardEditable(
        moduleId: 'at_a_glance',
        isCustomizing: widget.isCustomizing,
        onDragStarted: () {
          _startDragging('at_a_glance');
        },
        onDragEnd: _stopDragging,
        child: WorkspaceAtAGlance(accentColor: config.accentColor),
      ),
    );
  }

  // ============================================================
  // COMPACT
  // ============================================================

  Widget _buildRightColumnModule(
    String moduleId,
    WorkspaceDashboardConfig config,
  ) {
    Widget content;

    switch (moduleId) {
      case 'health':
        content = WorkspaceHealthCard(config: config);
        break;

      case 'activity':
        content = WorkspaceActivity(config: config);
        break;

      case 'messaging':
        content = WorkspaceMessaging(config: config);
        break;

      default:
        return const SizedBox.shrink();
    }

    return WorkspaceDashboardDropTarget(
      moduleId: moduleId,
      onDrop: _dropOnRightColumnModule,
      child: WorkspaceDashboardEditable(
        moduleId: moduleId,
        isCustomizing: widget.isCustomizing,
        onDragStarted: () {
          _startRightColumnDragging(moduleId);
        },
        onDragEnd: _stopDragging,
        child: content,
      ),
    );
  }

  Widget _buildCompactLayout(WorkspaceDashboardConfig config) {
    final essentialsPosition =
        _layoutController.findModule('essentials')?.position ?? 999;

    final glancePosition =
        _layoutController.findModule('at_a_glance')?.position ?? 999;

    final essentialsFirst = essentialsPosition <= glancePosition;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // HERO — ANCHORED
        if (_layoutController.isVisible('hero'))
          WorkspaceDashboardHero(config: config, firstName: widget.firstName),

        if (_layoutController.isVisible('hero')) const SizedBox(height: 16),

        // TOGETHER — ANCHORED
        if (_layoutController.isVisible('inspiration'))
          WorkspaceInspirationCard(config: config),

        if (_layoutController.isVisible('inspiration'))
          const SizedBox(height: 16),

        // KPIs — ANCHORED
        if (_layoutController.isVisible('kpis'))
          WorkspaceKpiRow(config: config),

        if (_layoutController.isVisible('kpis')) const SizedBox(height: 20),

        if (essentialsFirst) ...[
          if (_layoutController.isVisible('essentials'))
            _buildEssentials(config),

          if (_layoutController.isVisible('essentials'))
            const SizedBox(height: 16),

          if (_layoutController.isVisible('at_a_glance'))
            _buildAtAGlance(config),
        ] else ...[
          if (_layoutController.isVisible('at_a_glance'))
            _buildAtAGlance(config),

          if (_layoutController.isVisible('at_a_glance'))
            const SizedBox(height: 16),

          if (_layoutController.isVisible('essentials'))
            _buildEssentials(config),
        ],

        const SizedBox(height: 16),

        // HEALTH
        if (_layoutController.isVisible('health'))
          WorkspaceDashboardEditable(
            moduleId: 'health',
            isCustomizing: widget.isCustomizing,
            child: WorkspaceHealthCard(config: config),
          ),

        if (_layoutController.isVisible('health')) const SizedBox(height: 16),

        // ACTIVITY
        if (_layoutController.isVisible('activity'))
          WorkspaceDashboardEditable(
            moduleId: 'activity',
            isCustomizing: widget.isCustomizing,
            child: WorkspaceActivity(config: config),
          ),

        if (_layoutController.isVisible('activity')) const SizedBox(height: 16),

        // MESSAGING
        if (_layoutController.isVisible('messaging'))
          WorkspaceDashboardEditable(
            moduleId: 'messaging',
            isCustomizing: widget.isCustomizing,
            child: WorkspaceMessaging(config: config),
          ),
      ],
    );
  }
}
