import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_workspace_task.dart';

const foundationTasks = [
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
