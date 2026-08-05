import 'package:flutter/material.dart';

import 'package:charitask/domain/organization/organization_type.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_selection_card.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/data/organization/organization_types.dart';

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

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(right: 8),
            itemCount: organizationTypes.length,
            itemBuilder: (context, index) {
              final option = organizationTypes[index];

              return CTJourneySelectionCard(
                icon: option.icon,
                title: option.title,
                subtitle: option.subtitle,
                selected: _selectedType == option.type,
                onTap: () {
                  setState(() {
                    _selectedType = option.type;
                  });
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
