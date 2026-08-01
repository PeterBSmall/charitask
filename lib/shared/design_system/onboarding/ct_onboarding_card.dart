import 'package:flutter/material.dart';

import 'ct_onboarding_constants.dart';

class CTOnboardingCard extends StatelessWidget {
  final Widget child;

  const CTOnboardingCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CTOnboardingSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(padding: CTOnboardingSpacing.cardPadding, child: child),
    );
  }
}
