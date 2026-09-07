import 'package:flutter/material.dart';

import '../models/ct_workspace.dart';

class CTWorkspaceService {
  static const List<CTWorkspace> initialWorkspaces = [
    CTWorkspace(
      id: 'organization',
      name: 'Organization Workspace',
      type: CTWorkspaceType.organization,
      icon: Icons.account_balance_rounded,
      color: Color(0xFF5B4BC4),
    ),
    CTWorkspace(
      id: 'personal',
      name: 'Personal Workspace',
      type: CTWorkspaceType.personal,
      icon: Icons.person_rounded,
      color: Color(0xFF5B4BC4),
    ),
  ];
}
