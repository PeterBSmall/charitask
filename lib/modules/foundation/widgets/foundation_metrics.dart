import 'package:flutter/material.dart';

import 'package:charitask/shared/widgets/dashboard/index.dart';

class FoundationMetrics extends StatelessWidget {
  const FoundationMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return CTMetricsGrid(
      children: const [
        CTMetricCard(icon: Icons.people, title: 'People', value: '148'),

        CTMetricCard(icon: Icons.groups, title: 'Groups', value: '12'),

        CTMetricCard(icon: Icons.location_on, title: 'Locations', value: '4'),

        CTMetricCard(icon: Icons.widgets, title: 'Suites', value: '7'),
      ],
    );
  }
}
