import 'package:flutter/material.dart';

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
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const PeoplePage()));
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
