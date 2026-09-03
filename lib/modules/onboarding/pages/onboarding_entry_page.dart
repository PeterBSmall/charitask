import 'package:flutter/material.dart';

import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:charitask/modules/onboarding/pages/account/create_account_page.dart';
import 'package:charitask/modules/onboarding/pages/verification/email_verification_page.dart';
import 'package:charitask/modules/onboarding/pages/role/your_role_page.dart';

import 'package:charitask/modules/organization/pages/organization_setup_screen.dart';

import 'package:charitask/modules/foundation/pages/identity/complete_personal_profile_page.dart';
import 'package:charitask/modules/foundation/pages/workspaces/foundation_workspace.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:charitask/modules/foundation/pages/onboarding/personal_workspace/personal_workspace_setup_page.dart';

class OnboardingEntryPage extends StatefulWidget {
  final bool launchedFromAuthCallback;

  const OnboardingEntryPage({super.key, this.launchedFromAuthCallback = false});

  @override
  State<OnboardingEntryPage> createState() => _OnboardingEntryPageState();
}

class _OnboardingEntryPageState extends State<OnboardingEntryPage> {
  late final OnboardingController _controller;

  bool _checkingSession = true;
  bool _hasSession = false;
  bool _resumeOnboarding = false;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController();

    _checkSession();
  }

  Future<void> _checkSession() async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    debugPrint(
      '>>> ONBOARDING SESSION CHECK: '
      '${session?.user.email ?? 'NO SESSION'}',
    );

    if (!mounted) return;

    // ------------------------------------------------------------
    // No authenticated session.
    // Continue with account creation.
    // ------------------------------------------------------------

    if (session == null) {
      setState(() {
        _hasSession = false;
        _checkingSession = false;
      });

      return;
    }

    final authUserId = session.user.id;

    debugPrint('>>> AUTH USER ID: $authUserId');
    debugPrint('>>> CHECKING CHARITASK PERSON IDENTITY');

    try {
      final identity = await supabase
          .from('person_auth_identities')
          .select('person_id')
          .eq('auth_user_id', authUserId)
          .maybeSingle();

      // ------------------------------------------------------------
      // Authenticated, but no ChariTask Person exists yet.
      //
      // This means authentication succeeded, but organization
      // provisioning/onboarding has not been completed.
      // ------------------------------------------------------------

      if (identity == null) {
        debugPrint('>>> NO CHARITASK PERSON IDENTITY FOUND');
        debugPrint('>>> CONTINUING ONBOARDING');

        _controller.loadAuthenticatedPerson();

        if (!mounted) return;

        setState(() {
          _hasSession = true;
          _resumeOnboarding = true;
          _checkingSession = false;
        });

        return;
      }

      // ------------------------------------------------------------
      // ChariTask identity exists.
      //
      // provision_initial_organization() creates this identity only
      // after the initial organization/person has been provisioned.
      // ------------------------------------------------------------

      debugPrint('>>> CHARITASK PERSON IDENTITY FOUND');
      debugPrint('>>> PERSON ID: ${identity['person_id']}');
      debugPrint('>>> RETURNING USER DETECTED');
      debugPrint('>>> ROUTING TO FOUNDATION WORKSPACE');

      if (!mounted) return;

      final journeyController = CTJourneyController();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              FoundationWorkspace(journeyController: journeyController),
        ),
      );
    } catch (error) {
      debugPrint('>>> ERROR CHECKING PERSON IDENTITY: $error');

      if (!mounted) return;

      // If we cannot determine the ChariTask identity, don't falsely
      // send the user into the workspace.
      setState(() {
        _hasSession = true;
        _checkingSession = false;
      });
    }
  }

  Future<void> _resumeAuthenticatedOnboarding() async {
    debugPrint('>>> RESUMING AUTHENTICATED ONBOARDING');

    if (!mounted) return;

    setState(() {
      _checkingSession = true;
    });

    await _checkSession();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendOnboardingEmail() async {
    final person = _controller.person;

    if (person?.email == null || person!.email!.trim().isEmpty) {
      debugPrint('No email address available for onboarding email.');
      return;
    }

    final email = person.email!.trim();
    final firstName = person.firstName.trim();

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'send-onboarding-email',
        body: {
          'to': email,
          'subject': 'Welcome to ChariTask, $firstName!',
          'html':
              '''
          <h1>Welcome to ChariTask, $firstName! 🎉</h1>
          <p>Your ChariTask account is ready.</p>
          <p>You have successfully completed your initial setup and are ready to begin using your workspace.</p>
          <p>We're excited to have you here!</p>
          <p><strong>— The ChariTask Team</strong></p>
        ''',
        },
      );

      debugPrint('Onboarding email sent: ${response.data}');
    } catch (e) {
      debugPrint('Failed to send onboarding email: $e');
    }
  }

  void _openPersonalProfile(CTJourneyController journeyController) {
    final person = _controller.person;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CompletePersonalProfilePage(
          firstName: person?.firstName ?? '',
          lastName: person?.lastName ?? '',
          email: person?.email ?? '',
          phone: person?.phone,
          organizationalRole: _controller.organizationRole?.name ?? '',
          onSkip: () {
            _finishOnboarding(journeyController);
          },
          onComplete:
              ({String? preferredName, String? pronouns, String? phone}) async {
                _controller.updatePerson(
                  preferredName: preferredName,
                  pronouns: pronouns,
                  phone: phone,
                );

                await _sendOnboardingEmail();

                _finishOnboarding(journeyController);
              },
        ),
      ),
    );
  }

  void _finishOnboarding(CTJourneyController journeyController) {
    debugPrint('>>> FINISH ONBOARDING: person = ${_controller.person}');
    debugPrint(
      '>>> FINISH ONBOARDING: person name = '
      '${_controller.person?.firstName} ${_controller.person?.lastName}',
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            PersonalWorkspaceSetupPage(onboardingController: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSession) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F6FA),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_resumeOnboarding) {
      return YourRolePage(
        controller: _controller,
        onBack: () {
          // Nothing to go back to from authenticated onboarding.
        },
        onContinue: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OrganizationSetupScreen(
                firstName: _controller.person?.firstName ?? '',
                onboardingController: _controller,
                onCompleteProfile: _openPersonalProfile,
                onComplete: (journeyController) {
                  _openPersonalProfile(journeyController);
                },
              ),
            ),
          );
        },
      );
    }
    return CreateAccountPage(
      controller: _controller,
      onSignedIn: _resumeAuthenticatedOnboarding,
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
                              onboardingController: _controller,
                              onCompleteProfile: _openPersonalProfile,
                              onComplete: (journeyController) {
                                _openPersonalProfile(journeyController);
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
