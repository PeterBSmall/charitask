import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_metric.dart';

const foundationMetrics = [
  CTMetric(
    icon: Icons.account_balance_outlined,
    value: 'Profile',
    label: 'Org',
  ),

  CTMetric(icon: Icons.people_outline, value: '148 Members', label: 'People'),

  CTMetric(icon: Icons.groups_outlined, value: '12 Teams', label: 'Groups'),

  CTMetric(
    icon: Icons.location_on_outlined,
    value: '4 Active',
    label: 'Locations',
  ),

  CTMetric(
    icon: Icons.dashboard_customize_outlined,
    value: '7 Modules',
    label: 'Suites',
  ),

  CTMetric(icon: Icons.task_alt_outlined, value: '18 Pending', label: 'Tasks'),

  CTMetric(
    icon: Icons.notifications_none_outlined,
    value: '3 Critical',
    label: 'Alerts',
  ),
];
