import 'package:flutter/material.dart';

class CTWorkspaceTask {
  final IconData icon;
  final String title;
  final String category;
  final Color color;
  final VoidCallback? onTap;

  const CTWorkspaceTask({
    required this.icon,
    required this.title,
    required this.category,
    required this.color,
    this.onTap,
  });
}
