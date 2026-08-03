import 'package:flutter/material.dart';

import 'package:charitask/domain/organization/organization_type.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_selection_card.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class CTOrganizationTypeStep extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  final CTJourneyController journeyController;

  const CTOrganizationTypeStep({
    super.key,
    required this.journeyController,
    required this.onContinue,
    required this.onBack,
  });
  @override
  State<CTOrganizationTypeStep> createState() => _CTOrganizationTypeStepState();
}

class _CTOrganizationTypeStepState extends State<CTOrganizationTypeStep> {
  OrganizationType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 3, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        CTJourneyHeader(
          title: 'Hello Peter.',
          question: 'What best describes your organization?',
          subtitle: 'This helps ChariTask tailor your experience.',
          icon: Icons.apartment_outlined,
        ),

        const SizedBox(height: 28),

        Column(
          children: [
            CTJourneySelectionCard(
              icon: Icons.favorite_outline,
              title: 'Nonprofit',
              subtitle: 'Charities and mission-driven organizations',
              selected: _selectedType == OrganizationType.nonprofit,
              onTap: () {
                setState(() {
                  _selectedType = OrganizationType.nonprofit;
                });
              },
            ),

            CTJourneySelectionCard(
              icon: Icons.church_outlined,
              title: 'Church',
              subtitle: 'Faith-based organizations',
              selected: _selectedType == OrganizationType.church,
              onTap: () {
                setState(() {
                  _selectedType = OrganizationType.church;
                });
              },
            ),

            CTJourneySelectionCard(
              icon: Icons.school_outlined,
              title: 'School',
              subtitle: 'Public or private educational organizations',
              selected: _selectedType == OrganizationType.school,
              onTap: () {
                setState(() {
                  _selectedType = OrganizationType.school;
                });
              },
            ),
          ],
        ),
        const Spacer(),

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
                onPressed: _selectedType == null
                    ? null
                    : () {
                        widget.journeyController.updateOrganizationType(
                          _selectedType!,
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
