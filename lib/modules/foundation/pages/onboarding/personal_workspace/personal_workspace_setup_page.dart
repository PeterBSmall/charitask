import 'package:flutter/material.dart';

import 'package:charitask/modules/foundation/pages/identity/complete_personal_profile_page.dart';
import 'package:charitask/modules/foundation/pages/onboarding/personal_workspace/steps/personal_details_step.dart';
import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';

class PersonalWorkspaceSetupPage extends StatefulWidget {
  final OnboardingController onboardingController;

  const PersonalWorkspaceSetupPage({
    super.key,
    required this.onboardingController,
  });

  @override
  State<PersonalWorkspaceSetupPage> createState() =>
      _PersonalWorkspaceSetupPageState();
}

class _PersonalWorkspaceSetupPageState
    extends State<PersonalWorkspaceSetupPage> {
  bool _useForFutureWorkspaces = false;

  OnboardingController get onboardingController => widget.onboardingController;

  @override
  Widget build(BuildContext context) {
    final person = onboardingController.person;

    if (person == null) {
      return const Scaffold(
        body: Center(child: Text('Personal information is not available.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: PersonalDetailsStep(
          firstName: person.firstName,
          lastName: person.lastName,
          email: person.email ?? '',
          phone: person.phone,
          organizationalRole: onboardingController.organizationRole?.name ?? '',
          onEditDetails: _editDetails,
          onConfirm: _continueToTemplateSelection,
          onUseForFutureWorkspaces: (value) {
            setState(() {
              _useForFutureWorkspaces = value;
            });
          },
        ),
      ),
    );
  }

  void _editDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CompletePersonalProfilePage(
          firstName: onboardingController.person?.firstName ?? '',
          lastName: onboardingController.person?.lastName ?? '',
          email: onboardingController.person?.email ?? '',
          phone: onboardingController.person?.phone,
          organizationalRole: onboardingController.organizationRole?.name ?? '',
          onSkip: () {
            Navigator.of(context).pop();
          },
          onComplete:
              ({String? preferredName, String? pronouns, String? phone}) async {
                onboardingController.updatePerson(
                  preferredName: preferredName,
                  pronouns: pronouns,
                  phone: phone,
                );

                Navigator.of(context).pop();
              },
        ),
      ),
    );
  }

  void _continueToTemplateSelection() {
    // Step 2 will be connected here next.
    debugPrint(
      'Personal workspace details confirmed. '
      'Use for future workspaces: $_useForFutureWorkspaces',
    );
  }
}
