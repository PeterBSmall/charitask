import 'package:flutter/material.dart';

import '../modules/foundation/foundation_workspace.dart';

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
      ),

      home: const FoundationWorkspace(),
    );
  }
}