import 'package:flutter/material.dart';

import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';

class EmailVerificationPage extends StatelessWidget {
  final OnboardingController controller;
  final VoidCallback onContinue;

  const EmailVerificationPage({
    super.key,
    required this.controller,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final person = controller.person;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mark_email_unread_outlined, size: 64),

                  const SizedBox(height: 24),

                  Text(
                    'Verify your email',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    person?.email != null
                        ? 'We sent a verification link to ${person!.email}.'
                        : 'We sent a verification link to your email address.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: () {
                      controller.markEmailVerified();
                      onContinue();
                    },
                    child: const Text('I verified my email'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
