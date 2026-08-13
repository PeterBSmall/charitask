import 'package:flutter/material.dart';

import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:charitask/modules/onboarding/pages/account/create_account_page.dart';
import 'package:charitask/modules/onboarding/pages/verification/email_verification_page.dart';
import 'package:charitask/modules/onboarding/pages/role/your_role_page.dart';
import 'package:charitask/modules/organization/pages/organization_setup_screen.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace_page.dart';

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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => YourRolePage(
                      controller: _controller,
                      onBack: () {
                        Navigator.of(context).pop();
                      },
                      onContinue: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OrganizationSetupScreen(
                              firstName: _controller.person?.firstName ?? '',
                              onComplete: (journeyController) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) => FoundationWorkspacePage(
                                      journeyController: journeyController,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
