import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';
import 'package:charitask/shared/widgets/dashboard/index.dart';

class FoundationMetrics extends StatelessWidget {
  const FoundationMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return CTMetricsGrid(
      children: const [
        CTMetricCard(
          metric: CTMetric(icon: Icons.people, label: 'People', value: '148'),
        ),

        CTMetricCard(
          metric: CTMetric(icon: Icons.groups, label: 'Groups', value: '12'),
        ),

        CTMetricCard(
          metric: CTMetric(
            icon: Icons.location_on,
            label: 'Locations',
            value: '4',
          ),
        ),

        CTMetricCard(
          metric: CTMetric(icon: Icons.widgets, label: 'Suites', value: '7'),
        ),
      ],
    );
  }
}
