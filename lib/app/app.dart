import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/design_system.dart';

import '../modules/foundation/pages/workspaces/foundation_workspace.dart';

class ChariTaskApp extends StatelessWidget {
  const ChariTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChariTask',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      home: const FoundationWorkspace(),
    );
  }
}
