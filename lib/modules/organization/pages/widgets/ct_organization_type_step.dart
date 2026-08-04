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

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CTJourneySelectionCard(
                  icon: Icons.favorite_outline,
                  title: 'Nonprofit',
                  subtitle:
                      'Mission-driven organizations serving their communities.',
                  selected: _selectedType == OrganizationType.nonprofit,
                  onTap: () {
                    setState(() {
                      _selectedType = OrganizationType.nonprofit;
                    });
                  },
                ),

                CTJourneySelectionCard(
                  icon: Icons.church_outlined,
                  title: 'Church / Faith Organization',
                  subtitle:
                      'Faith communities connecting people through worship and service.',
                  selected: _selectedType == OrganizationType.church,
                  onTap: () {
                    setState(() {
                      _selectedType = OrganizationType.church;
                    });
                  },
                ),

                CTJourneySelectionCard(
                  icon: Icons.school_outlined,
                  title: 'School / Educational Organization',
                  subtitle:
                      'Organizations dedicated to education and lifelong learning.',
                  selected: _selectedType == OrganizationType.school,
                  onTap: () {
                    setState(() {
                      _selectedType = OrganizationType.school;
                    });
                  },
                ),

                CTJourneySelectionCard(
                  icon: Icons.account_balance_outlined,
                  title: 'Municipality / Public Service',
                  subtitle:
                      'Serving citizens through public programs and community services.',
                  selected: _selectedType == OrganizationType.municipality,
                  onTap: () {
                    setState(() {
                      _selectedType = OrganizationType.municipality;
                    });
                  },
                ),

                CTJourneySelectionCard(
                  icon: Icons.business_outlined,
                  title: 'Business / Company',
                  subtitle:
                      'Purpose-driven companies creating positive impact.',
                  selected: _selectedType == OrganizationType.business,
                  onTap: () {
                    setState(() {
                      _selectedType = OrganizationType.business;
                    });
                  },
                ),
              ],
            ),
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
