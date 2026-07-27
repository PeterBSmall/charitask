import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';

const foundationMetrics = [
  CTMetric(
    icon: Icons.people,
    value: '148',
    label: 'People',
    trend: '+12 this month',
    trendColor: Colors.green,
  ),

  CTMetric(
    icon: Icons.group_work,
    value: '12',
    label: 'Groups',
    trend: '2 new',
    trendColor: Colors.green,
  ),

  CTMetric(
    icon: Icons.location_on,
    value: '4',
    label: 'Locations',
    trend: 'No change',
  ),

  CTMetric(
    icon: Icons.dashboard_customize,
    value: '7',
    label: 'Suites',
    trend: 'All Active',
    trendColor: Colors.green,
  ),

  CTMetric(
    icon: Icons.task_alt,
    value: '18',
    label: 'Tasks',
    trend: '4 Recommended',
    trendColor: Colors.orange,
  ),

  CTMetric(
    icon: Icons.notifications,
    value: '3',
    label: 'Alerts',
    trend: 'Needs Review',
    trendColor: Colors.red,
  ),
];
