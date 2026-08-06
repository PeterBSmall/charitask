import 'package:flutter/material.dart';

import 'package:charitask/domain/organization/organization_mission.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_selection_card.dart';

import 'package:charitask/shared/data/organization/organization_missions.dart';

class CTOrganizationMissionStep extends StatefulWidget {
  final CTJourneyController journeyController;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const CTOrganizationMissionStep({
    super.key,
    required this.journeyController,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<CTOrganizationMissionStep> createState() =>
      _CTOrganizationMissionStepState();
}

class _CTOrganizationMissionStepState extends State<CTOrganizationMissionStep> {
  OrganizationMission? _selectedMission;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 6, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        const CTJourneyHeader(
          title: 'Hello Peter.',
          question: 'What is your organization\'s primary mission?',
          subtitle: 'Choose the mission that best reflects your organization.',
          icon: Icons.volunteer_activism_outlined,
        ),

        const SizedBox(height: 28),

        Expanded(
          child: ListView.builder(
            itemCount: organizationMissions.length,
            itemBuilder: (context, index) {
              final option = organizationMissions[index];

              return CTJourneySelectionCard(
                icon: option.icon,
                title: option.title,
                subtitle: option.subtitle,
                selected: _selectedMission == option.mission,
                onTap: () {
                  setState(() {
                    _selectedMission = option.mission;
                  });

                  widget.journeyController.updateOrganizationMission(
                    option.mission,
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onBack,
                child: const Text('Back'),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: CTJourneyButton(
                text: 'Continue',
                onPressed: _selectedMission == null
                    ? null
                    : () {
                        widget.journeyController.updateOrganizationMission(
                          _selectedMission!,
                        );

                        widget.onContinue();
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
