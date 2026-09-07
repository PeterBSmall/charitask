import 'package:flutter/material.dart';

enum CTWorkspaceType { organization, personal, team, program, custom }

class CTWorkspace {
  final String id;
  final String name;
  final CTWorkspaceType type;
  final IconData icon;
  final Color color;

  const CTWorkspace({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  });

  bool get isPersonal => type == CTWorkspaceType.personal;

  bool get isOrganization => type == CTWorkspaceType.organization;
}
