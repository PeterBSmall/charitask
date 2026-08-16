import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/design_system.dart';
import 'package:charitask/modules/onboarding/pages/onboarding_entry_page.dart';

class ChariTaskApp extends StatelessWidget {
  final bool launchedFromAuthCallback;

  const ChariTaskApp({super.key, this.launchedFromAuthCallback = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChariTask',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      home: OnboardingEntryPage(
        launchedFromAuthCallback: launchedFromAuthCallback,
      ),
    );
  }
}
