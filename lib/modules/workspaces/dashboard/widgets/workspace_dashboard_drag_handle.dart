import 'package:flutter/material.dart';

class WorkspaceDashboardDragHandle extends StatelessWidget {
  final String moduleId;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;

  const WorkspaceDashboardDragHandle({
    super.key,
    required this.moduleId,
    this.onDragStarted,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: moduleId,

      onDragStarted: () {
        onDragStarted?.call();
      },

      onDragEnd: (_) {
        onDragEnd?.call();
      },

      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.02,
          child: Opacity(
            opacity: 0.96,
            child: Container(
              width: 190,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2563EB), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.16),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.drag_indicator_rounded,
                    size: 19,
                    color: Color(0xFF2563EB),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Moving module',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF17204D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      childWhenDragging: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: const Color(0xFF2563EB).withValues(alpha: 0.30),
          ),
        ),
        child: const Icon(
          Icons.drag_indicator_rounded,
          size: 19,
          color: Color(0xFF2563EB),
        ),
      ),

      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: const Color(0xFFE1E6F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.drag_indicator_rounded,
            size: 19,
            color: Color(0xFF68738A),
          ),
        ),
      ),
    );
  }
}
