import 'package:flutter/material.dart';

import '../models/ct_workspace.dart';

class CTWorkspaceService {
  static final List<CTWorkspace> workspaces = [
    const CTWorkspace(
      id: 'organization',
      name: 'Organization Workspace',
      type: CTWorkspaceType.organization,
      icon: Icons.account_balance_rounded,
      color: Color(0xFF5B4BC4),
    ),
    const CTWorkspace(
      id: 'personal',
      name: 'Personal Workspace',
      type: CTWorkspaceType.personal,
      icon: Icons.person_rounded,
      color: Color(0xFF6FA64A),
    ),
  ];

  static CTWorkspace createWorkspace({
    required String id,
    required String name,
    required CTWorkspaceType type,
    required IconData icon,
    required Color color,
  }) {
    final workspace = CTWorkspace(
      id: id,
      name: name,
      type: type,
      icon: icon,
      color: color,
    );

    workspaces.add(workspace);

    return workspace;
  }
}
