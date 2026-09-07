import 'package:flutter/material.dart';

import 'package:charitask/shared/workspaces/models/ct_workspace.dart';
import 'package:charitask/shared/workspaces/services/ct_workspace_service.dart';

class MissionControlShell extends StatefulWidget {
  final Widget child;

  const MissionControlShell({super.key, required this.child});

  @override
  State<MissionControlShell> createState() => _MissionControlShellState();
}

class _MissionControlShellState extends State<MissionControlShell> {
  static const double _railWidth = 72.0;

  late final List<CTWorkspace> _workspaces;

  String _activeWorkspaceId = 'organization';

  @override
  void initState() {
    super.initState();

    _workspaces = CTWorkspaceService.initialWorkspaces;
  }

  void _selectWorkspace(CTWorkspace workspace) {
    setState(() {
      _activeWorkspaceId = workspace.id;
    });

    debugPrint('>>> WORKSPACE SELECTED: ${workspace.name}');
  }

  void _createWorkspace() {
    debugPrint('>>> CREATE WORKSPACE');
  }

  void _openMissionControl() {
    debugPrint('>>> MISSION CONTROL');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            _buildGlobalRail(),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalRail() {
    return Container(
      width: _railWidth,
      decoration: const BoxDecoration(
        color: Color(0xFFF1EEE8),
        border: Border(right: BorderSide(color: Color(0xFFDCD8D0))),
      ),
      child: Column(
        children: [
          _buildMissionControlHeader(),

          const Divider(height: 1, color: Color(0xFFDCD8D0)),

          Expanded(child: _buildWorkspaceRail()),
        ],
      ),
    );
  }

  Widget _buildMissionControlHeader() {
    return SizedBox(
      height: 104,
      child: Center(
        child: Tooltip(
          message: 'Mission Control',
          waitDuration: const Duration(milliseconds: 350),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _openMissionControl,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B4BC4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkspaceRail() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        for (final workspace in _workspaces) _buildWorkspaceIcon(workspace),

        const SizedBox(height: 12),

        _buildAddWorkspaceButton(),
      ],
    );
  }

  Widget _buildWorkspaceIcon(CTWorkspace workspace) {
    final isActive = workspace.id == _activeWorkspaceId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Tooltip(
        message: workspace.name,
        waitDuration: const Duration(milliseconds: 350),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _selectWorkspace(workspace),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFE2DDD3) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFFCEC6B8)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                workspace.icon,
                size: 23,
                color: isActive
                    ? const Color(0xFF4A3D35)
                    : const Color(0xFF5F5A54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddWorkspaceButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Tooltip(
        message: 'Create Workspace',
        waitDuration: const Duration(milliseconds: 350),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _createWorkspace,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB9B2A8)),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 24,
                color: Color(0xFF5F5A54),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
