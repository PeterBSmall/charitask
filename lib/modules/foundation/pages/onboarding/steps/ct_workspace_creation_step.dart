import 'package:flutter/material.dart';

import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/shared/data/ct_journey_heroes.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/preparation/ct_workspace_preparation_step.dart';

import '../widgets/ct_workspace_completion_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:charitask/modules/onboarding/controllers/onboarding_controller.dart';

class CTWorkspaceCreationStep extends StatefulWidget {
  final CTMissionProfile profile;
  final CTJourneyController journeyController;
  final OnboardingController onboardingController;
  final VoidCallback onContinue;
  final VoidCallback onCompleteProfile;

  const CTWorkspaceCreationStep({
    super.key,
    required this.profile,
    required this.journeyController,
    required this.onboardingController,
    required this.onContinue,
    required this.onCompleteProfile,
  });

  @override
  State<CTWorkspaceCreationStep> createState() =>
      _CTWorkspaceCreationStepState();
}

class _CTWorkspaceCreationStepState extends State<CTWorkspaceCreationStep> {
  bool _showCompletionScreen = false;

  Future<void> _provisionWorkspace() async {
    final supabase = Supabase.instance.client;
    final person = widget.onboardingController.person;

    final session = supabase.auth.currentSession;

    if (session == null) {
      _showError('Your session has expired. Please sign in again.');
      return;
    }

    if (person == null) {
      _showError('We could not find your account information.');
      return;
    }

    final organizationName = widget.journeyController.organization.identity.name
        .trim();

    if (organizationName.isEmpty) {
      _showError('Organization name is required.');
      return;
    }

    final firstName = person.firstName.trim();
    final lastName = person.lastName.trim();
    final email = person.email?.trim();
    final phone = person.phone?.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      _showError('Your first and last name are required.');
      return;
    }

    // Convert the organization name into a URL-safe slug.
    final organizationSlug = organizationName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    if (organizationSlug.isEmpty) {
      _showError('We could not create a valid organization identifier.');
      return;
    }

    try {
      debugPrint('>>> PROVISIONING INITIAL ORGANIZATION');
      debugPrint('>>> ORGANIZATION: $organizationName');
      debugPrint('>>> SLUG: $organizationSlug');
      debugPrint('>>> PERSON: $firstName $lastName');
      debugPrint('>>> AUTH USER: ${session.user.id}');

      final result = await supabase.rpc(
        'provision_initial_organization',
        params: {
          'p_organization_name': organizationName,
          'p_organization_slug': organizationSlug,
          'p_first_name': firstName,
          'p_last_name': lastName,
          'p_email': email,
          'p_phone': phone,
          'p_organization_role_slug': 'founder',
          'p_organization_role_name': 'Founder',
          'p_location_name':
              widget.journeyController.organizationLocation.trim().isEmpty
              ? null
              : widget.journeyController.organizationLocation.trim(),
        },
      );

      debugPrint('>>> PROVISIONING SUCCESS');
      debugPrint('>>> RESULT: $result');

      if (!mounted) return;

      widget.journeyController.setContextHero(CTJourneyHeroes.completion);

      setState(() {
        _showCompletionScreen = true;
      });
    } catch (error) {
      debugPrint('>>> PROVISIONING FAILED: $error');

      if (!mounted) return;

      _showError(
        'We could not finish setting up your workspace. '
        'Please try again.',
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _showCompletionScreen
        ? CTWorkspaceCompletionScreen(
            profile: widget.profile,
            onCompleteProfile: widget.onCompleteProfile,
            onGoToWorkspace: widget.onContinue,
          )
        : CTWorkspacePreparationStep(
            profile: widget.profile,
            onContinue: _provisionWorkspace,
          );
  }
}
