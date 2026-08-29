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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Wide desktop:
        // Keep the reference design of seven cards in one row.
        if (width >= 1200) {
          return _buildGrid(crossAxisCount: 7);
        }

        // Medium desktop:
        // Four cards per row.
        if (width >= 900) {
          return _buildGrid(crossAxisCount: 4);
        }

        // Tablet / smaller desktop:
        // Three cards per row.
        if (width >= 650) {
          return _buildGrid(crossAxisCount: 3);
        }

        // Narrow:
        // Two cards per row.
        if (width >= 400) {
          return _buildGrid(crossAxisCount: 2);
        }

        // Very narrow:
        // One card per row.
        return _buildGrid(crossAxisCount: 1);
      },
    );
  }

  Widget _buildGrid({required int crossAxisCount}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: _getAspectRatio(crossAxisCount),
      ),
      itemBuilder: (context, index) {
        final metric = widget.metrics[index];

        return CTMetricCard(
          metric: metric,
          isSelected: index == _selectedIndex,
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });

            widget.onMetricSelected?.call(index);
          },
        );
      },
    );
  }

  double _getAspectRatio(int crossAxisCount) {
    switch (crossAxisCount) {
      case 7:
        return 1.05;
      case 4:
        return 1.45;
      case 3:
        return 1.45;
      case 2:
        return 1.55;
      default:
        return 3.0;
    }
  }
}
