import 'package:flutter/material.dart';

class SuiteDefinition {
  final String id;
  final String title;
  final String subtitle;

  final IconData icon;

  final Color accentColor;

  final List<SuiteModule> modules;

  const SuiteDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.modules,
  });
}

class SuiteModule {
  final String title;
  final String description;
  final IconData icon;

  const SuiteModule({
    required this.title,
    required this.description,
    required this.icon,
  });
}
