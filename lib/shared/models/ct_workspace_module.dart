import 'package:flutter/material.dart';

class CTWorkspaceModule {
  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final Color color;
  final VoidCallback? onTap;

  const CTWorkspaceModule({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
    this.onTap,
  });
}
