import 'package:flutter/material.dart';

class CTMetricsGrid extends StatelessWidget {
  final List<Widget> children;

  const CTMetricsGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: children
          .map((child) => SizedBox(width: 250, child: child))
          .toList(),
    );
  }
}
