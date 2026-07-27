import 'package:flutter/material.dart';

import '../modules/foundation/pages/workspaces/foundation_workspace.dart';

import 'package:charitask/shared/theme/app_scrollbar_theme.dart';

class ChariTaskApp extends StatelessWidget {
  const ChariTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChariTask',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,

        scrollbarTheme: AppScrollbarTheme.light,
      ),

      home: const FoundationWorkspace(),
    );
  }
}
