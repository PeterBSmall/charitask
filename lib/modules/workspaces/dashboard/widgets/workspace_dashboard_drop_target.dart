import 'package:flutter/material.dart';

class WorkspaceDashboardDropTarget extends StatefulWidget {
  final String moduleId;
  final Widget child;
  final ValueChanged<String> onDrop;

  const WorkspaceDashboardDropTarget({
    super.key,
    required this.moduleId,
    required this.child,
    required this.onDrop,
  });

  @override
  State<WorkspaceDashboardDropTarget> createState() =>
      _WorkspaceDashboardDropTargetState();
}

class _WorkspaceDashboardDropTargetState
    extends State<WorkspaceDashboardDropTarget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        final accepted = details.data != widget.moduleId;

        if (accepted && mounted) {
          setState(() {
            _isHovering = true;
          });
        }

        return accepted;
      },
      onLeave: (_) {
        if (mounted) {
          setState(() {
            _isHovering = false;
          });
        }
      },
      onAcceptWithDetails: (details) {
        if (mounted) {
          setState(() {
            _isHovering = false;
          });
        }

        if (details.data != widget.moduleId) {
          widget.onDrop(widget.moduleId);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovering ? const Color(0xFF2563EB) : Colors.transparent,
              width: 2,
            ),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.10),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: widget.child,
        );
      },
    );
  }
}
