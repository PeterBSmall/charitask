import 'package:flutter/material.dart';

import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/shared/data/ct_journey_heroes.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/preparation/ct_workspace_preparation_step.dart';

import '../widgets/ct_workspace_completion_screen.dart';

class CTWorkspaceCreationStep extends StatefulWidget {
  final CTMissionProfile profile;
  final CTJourneyController journeyController;
  final VoidCallback onContinue;
  final VoidCallback onCompleteProfile;

  const CTWorkspaceCreationStep({
    super.key,
    required this.profile,
    required this.journeyController,
    required this.onContinue,
    required this.onCompleteProfile,
  });

  @override
  State<CTWorkspaceCreationStep> createState() =>
      _CTWorkspaceCreationStepState();
}

class _CTWorkspaceCreationStepState extends State<CTWorkspaceCreationStep> {
  bool _showCompletionScreen = false;

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
            onContinue: () {
              widget.journeyController.setContextHero(
                CTJourneyHeroes.completion,
              );

              setState(() {
                _showCompletionScreen = true;
              });
            },
          );
  }
}
