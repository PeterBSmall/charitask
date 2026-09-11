import 'package:flutter/material.dart';

import 'workspace_dashboard_drag_handle.dart';

enum WorkspaceDashboardHandlePosition { topLeft, topRight }

class WorkspaceDashboardEditable extends StatelessWidget {
  final Widget child;
  final bool isCustomizing;
  final String? moduleId;
  final VoidCallback? onTap;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;
  final WorkspaceDashboardHandlePosition handlePosition;

  const WorkspaceDashboardEditable({
    super.key,
    required this.child,
    required this.isCustomizing,
    this.moduleId,
    this.onTap,
    this.onDragStarted,
    this.onDragEnd,
    this.handlePosition = WorkspaceDashboardHandlePosition.topRight,
  });

  @override
  Widget build(BuildContext context) {
    if (!isCustomizing) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF2563EB).withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: child,
        ),
        Positioned(
          top: -8,
          left: handlePosition == WorkspaceDashboardHandlePosition.topLeft
              ? 12.0
              : null,
          right: handlePosition == WorkspaceDashboardHandlePosition.topRight
              ? 12.0
              : null,
          child: WorkspaceDashboardDragHandle(
            moduleId: moduleId ?? '',
            onDragStarted: onDragStarted,
            onDragEnd: onDragEnd,
          ),
        ),
      ],
    );
  }
}
