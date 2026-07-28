import 'package:flutter/material.dart';

import '../models/suite_definition.dart';
import '../design_system/foundations/app_colors.dart';

const foundationSuite = SuiteDefinition(
  id: 'foundation',

  title: 'Foundation',

  subtitle: 'Build the organizational foundation that powers every workspace.',

  icon: Icons.account_balance,

  accentColor: AppColors.missionPurple,

  modules: [
    SuiteModule(
      title: 'Organization',
      description: 'Mission, vision, identity and branding',
      icon: Icons.business,
    ),

    SuiteModule(
      title: 'People',
      description: 'Employees, volunteers and members',
      icon: Icons.people,
    ),

    SuiteModule(
      title: 'Locations',
      description: 'Campuses, offices and job sites',
      icon: Icons.location_on,
    ),

    SuiteModule(
      title: 'Groups',
      description: 'Departments, ministries and teams',
      icon: Icons.groups,
    ),

    SuiteModule(
      title: 'Organizational Roles',
      description: 'Board, employee and volunteer roles',
      icon: Icons.account_balance,
    ),

    SuiteModule(
      title: 'Functional Roles',
      description: 'Cashier, driver, builder and more',
      icon: Icons.build,
    ),

    SuiteModule(
      title: 'Suites',
      description: 'Enable ChariTask capabilities',
      icon: Icons.widgets,
    ),

    SuiteModule(
      title: 'Settings',
      description: 'Global Foundation configuration',
      icon: Icons.settings,
    ),
  ],
);
