import 'package:flutter/material.dart';

class CTMetric {
  final IconData icon;
  final String label;
  final String value;

  final String? trend;
  final Color? trendColor;

  const CTMetric({
    required this.icon,
    required this.label,
    required this.value,
    this.trend,
    this.trendColor,
  });
}
