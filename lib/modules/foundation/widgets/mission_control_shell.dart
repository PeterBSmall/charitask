import 'package:flutter/material.dart';
import 'package:charitask/modules/foundation/pages/workspaces/workspaces_page.dart';

class MissionControlShell extends StatefulWidget {
  final Widget child;

  const MissionControlShell({super.key, required this.child});

  @override
  State<MissionControlShell> createState() => _MissionControlShellState();
}

class _MissionControlShellState extends State<MissionControlShell> {
  bool _isCollapsed = false;
  int _selectedIndex = 0;

  static const _railExpandedWidth = 190.0;
  static const _railCollapsedWidth = 72.0;

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
    final width = _isCollapsed ? _railCollapsedWidth : _railExpandedWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFF1EEE8),
        border: Border(right: BorderSide(color: Color(0xFFDCD8D0))),
      ),
      child: Column(
        children: [
          _buildMissionControlHeader(),
          const Divider(height: 1, color: Color(0xFFDCD8D0)),
          Expanded(child: _buildWorkspaceRail()),
          _buildCollapseButton(),
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
    );
  }

  Widget _buildWorkspaceRail() {
    const workspaces = [
      _WorkspaceRailItem(
        icon: Icons.account_balance_rounded,
        name: 'Organization Workspace',
        isActive: true,
      ),
      _WorkspaceRailItem(
        icon: Icons.person_rounded,
        name: 'Personal Workspace',
      ),
      _WorkspaceRailItem(
        icon: Icons.business_rounded,
        name: 'Falmouth ReStore',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        for (final workspace in workspaces) _buildWorkspaceIcon(workspace),
        const SizedBox(height: 12),
        _buildAddWorkspaceButton(),
      ],
    );
  }

  Widget _buildWorkspaceIcon(_WorkspaceRailItem workspace) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Tooltip(
        message: workspace.name,
        waitDuration: const Duration(milliseconds: 350),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              debugPrint('>>> WORKSPACE SELECTED: ${workspace.name}');
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: workspace.isActive
                    ? const Color(0xFFE2DDD3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: workspace.isActive
                      ? const Color(0xFFCEC6B8)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                workspace.icon,
                size: 23,
                color: workspace.isActive
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Tooltip(
        message: 'New Workspace',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              debugPrint('>>> NEW WORKSPACE');
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFB9B2A8),
                  style: BorderStyle.solid,
                ),
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

  Widget _buildCollapseButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      child: Tooltip(
        message: _isCollapsed
            ? 'Expand Mission Control'
            : 'Collapse Mission Control',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() {
                _isCollapsed = !_isCollapsed;
              });
            },
            child: SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCollapsed
                        ? Icons.chevron_right_rounded
                        : Icons.chevron_left_rounded,
                    size: 25,
                    color: const Color(0xFF5F5A54),
                  ),
                  if (!_isCollapsed) ...[
                    const SizedBox(width: 4),
                    const Text(
                      'Collapse',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5F5A54),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkspaceRailItem {
  final IconData icon;
  final String name;
  final bool isActive;

  const _WorkspaceRailItem({
    required this.icon,
    required this.name,
    this.isActive = false,
  });
}
