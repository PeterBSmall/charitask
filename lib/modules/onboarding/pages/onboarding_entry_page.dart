import 'package:flutter/material.dart';

import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:charitask/modules/onboarding/pages/account/create_account_page.dart';
import 'package:charitask/modules/onboarding/pages/verification/email_verification_page.dart';

class OnboardingEntryPage extends StatefulWidget {
  const OnboardingEntryPage({super.key});

  @override
  State<OnboardingEntryPage> createState() => _OnboardingEntryPageState();
}

class _OnboardingEntryPageState extends State<OnboardingEntryPage> {
  late final OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CreateAccountPage(
      controller: _controller,
      onContinue: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EmailVerificationPage(
              controller: _controller,
              onContinue: () {
                // Owner Role will be connected next.
              },
            ),
          ),
        );
      },
    );
  }
}
