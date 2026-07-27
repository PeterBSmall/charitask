import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';
import 'package:charitask/shared/widgets/workspace/ct_metric_card.dart';

class CTWorkspaceMetrics extends StatelessWidget {
  final List<CTMetric> metrics;

  const CTWorkspaceMetrics({super.key, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;

        final cardWidth =
            (constraints.maxWidth - (spacing * (metrics.length - 1))) /
            metrics.length;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < metrics.length; i++) ...[
              SizedBox(
                width: cardWidth,
                child: CTMetricCard(metric: metrics[i]),
              ),
              if (i != metrics.length - 1) const SizedBox(width: spacing),
            ],
          ],
        );
      },
    );
  }
}
