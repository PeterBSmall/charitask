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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const spacing = 12.0;
    const minCardWidth = 150.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing = spacing * (widget.metrics.length - 1);

        final availableWidth = constraints.maxWidth - totalSpacing;

        final calculatedWidth = availableWidth / widget.metrics.length;

        final cardWidth = calculatedWidth < minCardWidth
            ? minCardWidth
            : calculatedWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < widget.metrics.length; i++) ...[
                SizedBox(
                  width: cardWidth,
                  child: CTMetricCard(
                    metric: widget.metrics[i],
                    isSelected: i == _selectedIndex,
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                      });

                      widget.onMetricSelected?.call(i);
                    },
                  ),
                ),
                if (i != widget.metrics.length - 1)
                  const SizedBox(width: spacing),
              ],
            ],
          ),
        );
      },
    );
  }
}
