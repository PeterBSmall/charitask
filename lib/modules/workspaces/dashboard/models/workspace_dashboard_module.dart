import 'package:flutter/material.dart';

enum WorkspaceDashboardModuleType {
  hero,
  inspiration,
  kpis,
  essentials,
  atAGlance,
  health,
  activity,
  messaging,
  custom,
}

class WorkspaceDashboardModule {
  final String id;
  final WorkspaceDashboardModuleType type;
  final String title;
  final bool visible;
  final int position;

  /// Whether the user can reposition this module
  /// while dashboard customization is enabled.
  final bool isMovable;

  const WorkspaceDashboardModule({
    required this.id,
    required this.type,
    required this.title,
    required this.visible,
    required this.position,
    this.isMovable = true,
  });

  WorkspaceDashboardModule copyWith({
    String? id,
    WorkspaceDashboardModuleType? type,
    String? title,
    bool? visible,
    int? position,
    bool? isMovable,
  }) {
    return WorkspaceDashboardModule(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      visible: visible ?? this.visible,
      position: position ?? this.position,
      isMovable: isMovable ?? this.isMovable,
    );
  }

  IconData get icon {
    switch (type) {
      case WorkspaceDashboardModuleType.hero:
        return Icons.auto_awesome_outlined;

      case WorkspaceDashboardModuleType.inspiration:
        return Icons.favorite_outline;

      case WorkspaceDashboardModuleType.kpis:
        return Icons.analytics_outlined;

      case WorkspaceDashboardModuleType.essentials:
        return Icons.bolt_rounded;

      case WorkspaceDashboardModuleType.atAGlance:
        return Icons.dashboard_customize_outlined;

      case WorkspaceDashboardModuleType.health:
        return Icons.favorite_outline;

      case WorkspaceDashboardModuleType.activity:
        return Icons.history_rounded;

      case WorkspaceDashboardModuleType.messaging:
        return Icons.chat_bubble_outline_rounded;

      case WorkspaceDashboardModuleType.custom:
        return Icons.widgets_outlined;
    }
  }
}
