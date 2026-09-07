import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';
import 'package:charitask/shared/widgets/workspace/ct_metric_card.dart';

class CTWorkspaceMetrics extends StatefulWidget {
  final List<CTMetric> metrics;
  final ValueChanged<int>? onMetricSelected;

  const CTWorkspaceMetrics({
    super.key,
    required this.metrics,
    this.onMetricSelected,
  });

  @override
  State<CTWorkspaceMetrics> createState() => _CTWorkspaceMetricsState();
}

class _CTWorkspaceMetricsState extends State<CTWorkspaceMetrics> {
  late List<CTMetric> _metrics;

  // Only ONE card can be selected at a time.
  int? _selectedIndex;

  // Card currently being dragged.
  int? _draggingIndex;

  static const double _spacing = 14;
  static const double _cardHeight = 80;

  @override
  void initState() {
    super.initState();
    _metrics = List<CTMetric>.from(widget.metrics);
  }

  @override
  void didUpdateWidget(covariant CTWorkspaceMetrics oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.metrics != widget.metrics) {
      _metrics = List<CTMetric>.from(widget.metrics);

      // Keep selection valid after a data refresh.
      if (_selectedIndex != null && _selectedIndex! >= _metrics.length) {
        _selectedIndex = null;
      }
    }
  }

  void _selectCard(int index) {
    setState(() {
      // Clicking the selected card again clears the selection.
      if (_selectedIndex == index) {
        _selectedIndex = null;
      } else {
        // Selecting another card automatically deselects
        // the previously selected card.
        _selectedIndex = index;
      }
    });

    widget.onMetricSelected?.call(index);
  }

  void _startDrag(int index) {
    setState(() {
      _draggingIndex = index;
    });
  }

  void _endDrag() {
    if (!mounted) return;

    setState(() {
      _draggingIndex = null;
    });
  }

  void _reorderCard(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) {
      _endDrag();
      return;
    }

    setState(() {
      final movedMetric = _metrics.removeAt(oldIndex);

      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      _metrics.insert(newIndex, movedMetric);

      // Keep the selected card attached to the same metric
      // after reordering.
      if (_selectedIndex != null) {
        if (_selectedIndex == oldIndex) {
          _selectedIndex = newIndex;
        } else if (oldIndex < _selectedIndex! && newIndex >= _selectedIndex!) {
          _selectedIndex = _selectedIndex! - 1;
        } else if (oldIndex > _selectedIndex! && newIndex <= _selectedIndex!) {
          _selectedIndex = _selectedIndex! + 1;
        }
      }

      _draggingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final columns = width >= 1100
            ? 4
            : width >= 700
            ? 2
            : 1;

        final cardWidth = columns == 1
            ? width
            : (width - ((columns - 1) * _spacing)) / columns;

        return Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: List.generate(_metrics.length, (index) {
            final metric = _metrics[index];

            final isSelected = _selectedIndex == index;
            final isDragging = _draggingIndex == index;

            return DragTarget<int>(
              onWillAcceptWithDetails: (details) {
                return details.data != index;
              },
              onAcceptWithDetails: (details) {
                _reorderCard(details.data, index);
              },
              builder: (context, candidateData, rejectedData) {
                final isDropTarget = candidateData.isNotEmpty;

                return SizedBox(
                  width: cardWidth,
                  height: _cardHeight,
                  child: Draggable<int>(
                    data: index,

                    // Start immediately when the user drags
                    // with the mouse. No long press required.
                    onDragStarted: () {
                      _startDrag(index);
                    },

                    onDragEnd: (_) {
                      _endDrag();
                    },

                    onDraggableCanceled: (_, __) {
                      _endDrag();
                    },

                    feedback: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: cardWidth,
                        height: _cardHeight,
                        child: Opacity(
                          opacity: 0.85,
                          child: CTMetricCard(
                            metric: metric,
                            isSelected: true,
                            onTap: null,
                          ),
                        ),
                      ),
                    ),

                    childWhenDragging: Opacity(
                      opacity: 0.25,
                      child: CTMetricCard(
                        metric: metric,
                        isSelected: false,
                        onTap: null,
                      ),
                    ),

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isDropTarget
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF5B4BC4,
                                  ).withValues(alpha: 0.22),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: MouseRegion(
                        cursor: isDragging
                            ? SystemMouseCursors.grabbing
                            : SystemMouseCursors.grab,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _selectCard(index);
                          },
                          child: CTMetricCard(
                            metric: metric,
                            isSelected: isSelected,
                            onTap: null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }
}
