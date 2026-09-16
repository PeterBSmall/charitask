import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// Existing in-memory workspace creation.
  ///
  /// Kept for existing workspace UI that has not yet been migrated
  /// to persistent Supabase workspaces.
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

  /// Creates a persistent personal workspace through Supabase.
  static Future<CTWorkspace> createPersonalWorkspace({
    required String name,
    required String description,
    required IconData icon,
    required Color color,
    required String templateId,
  }) async {
    final supabase = Supabase.instance.client;

    final result = await supabase.rpc(
      'create_personal_workspace',
      params: {
        'p_name': name,
        'p_description': description,
        'p_template_id': templateId,
      },
    );

    final data = Map<String, dynamic>.from(result as Map);

    final workspace = CTWorkspace(
      id: data['workspace_id'] as String,
      name: data['name'] as String,
      type: CTWorkspaceType.personal,
      icon: icon,
      color: color,
      templateId: data['template_id'] as String?,
    );

    workspaces.add(workspace);

    return workspace;
  }
}
