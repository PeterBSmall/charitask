import 'package:flutter/material.dart';

import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final email = person?.email;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Verification illustration
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1EDFF),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 78,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C4DFF),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.mail_outline_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        Positioned(
                          top: 18,
                          right: 12,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF5B35D5),
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'Verify your email',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 14),

                  Text(
                    email != null
                        ? 'We sent a verification link to'
                        : 'We sent a verification link to your email address.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),

                  if (email != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Resend area
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.access_time_rounded,
                          size: 22,
                          color: Color(0xFF5B35D5),
                        ),
                      ),
                      Container(
                        width: 72,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    "Haven't received the email?",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 4),

                  TextButton(
                    onPressed: () async {
                      try {
                        await controller.resendVerificationEmail();

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Verification email sent. Please check your inbox.',
                            ),
                          ),
                        );
                      } on AuthException catch (error) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(error.message)));
                      } catch (_) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'We could not resend the verification email. Please try again.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Resend verification email',
                      style: TextStyle(
                        color: Color(0xFF5B35D5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Verification button
                  SizedBox(
                    width: 460,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.markEmailVerified();
                        onContinue();
                      },
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: const Text(
                        'I verified my email',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                  // Help
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        size: 22,
                        color: const Color(0xFF5B35D5),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Need help? Visit our ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Help Center',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF5B35D5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
