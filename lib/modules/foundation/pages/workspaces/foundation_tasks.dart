import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:charitask/domain/organization/current_organization_context.dart';
import 'package:charitask/modules/people/pages/people_page.dart';
import 'package:charitask/shared/models/ct_workspace_task.dart';

List<CTWorkspaceTask> foundationTasks(BuildContext context) {
  return [
    CTWorkspaceTask(
      icon: Icons.location_on,
      title: 'Complete Locations',
      category: 'Foundation',
      color: Colors.orange,
    ),

    CTWorkspaceTask(
      icon: Icons.people,
      title: 'Invite Employees',
      category: 'People',
      color: Colors.blue,
      onTap: () async {
        final organizationId = await CurrentOrganizationContext(
          Supabase.instance.client,
        ).getOrganizationId();

        if (!context.mounted) return;

        if (organizationId == null || organizationId.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unable to load your organization.')),
          );
          return;
        }

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PeoplePage(organizationId: organizationId),
          ),
        );
      },
    ),

    CTWorkspaceTask(
      icon: Icons.badge,
      title: 'Configure Roles',
      category: 'Security',
      color: Colors.green,
    ),

    CTWorkspaceTask(
      icon: Icons.palette,
      title: 'Upload Logo',
      category: 'Branding',
      color: Colors.purple,
    ),
  ];
}
