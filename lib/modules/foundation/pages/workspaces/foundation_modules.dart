import 'package:flutter/material.dart';

import 'package:charitask/shared/models/ct_workspace_module.dart';
import 'package:charitask/shared/theme/app_colors.dart';

const foundationModules = [
  CTWorkspaceModule(
    icon: Icons.business,
    title: 'Org',
    subtitle: 'Profile',
    progress: 1.0,
    color: AppColors.missionPurple,
  ),

  CTWorkspaceModule(
    icon: Icons.people,
    title: 'People',
    subtitle: '148 Members',
    progress: .82,
    color: Colors.blue,
  ),

  CTWorkspaceModule(
    icon: Icons.location_on,
    title: 'Locations',
    subtitle: '4 Active',
    progress: .45,
    color: Colors.orange,
  ),

  CTWorkspaceModule(
    icon: Icons.groups,
    title: 'Groups',
    subtitle: '12 Teams',
    progress: .65,
    color: Colors.green,
  ),

  CTWorkspaceModule(
    icon: Icons.admin_panel_settings,
    title: 'Roles',
    subtitle: 'Permissions',
    progress: .25,
    color: Colors.red,
  ),

  CTWorkspaceModule(
    icon: Icons.security,
    title: 'Security',
    subtitle: 'Access Control',
    progress: .10,
    color: Colors.deepPurple,
  ),
];
