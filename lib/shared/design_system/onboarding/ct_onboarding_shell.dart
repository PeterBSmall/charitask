import 'package:flutter/material.dart';

import 'ct_onboarding_card.dart';

class CTOnboardingShell extends StatelessWidget {
  final Widget leftPanel;
  final Widget rightPanel;

  const CTOnboardingShell({
    super.key,
    required this.leftPanel,
    required this.rightPanel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1500),
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 6, child: leftPanel),

                  const SizedBox(width: 48),

                  Expanded(flex: 5, child: rightPanel),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
