import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_info_card.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_textfield.dart';

class CTOrganizationNameStep extends StatefulWidget {
  final CTJourneyController journeyController;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const CTOrganizationNameStep({
    super.key,
    required this.journeyController,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<CTOrganizationNameStep> createState() => _CTOrganizationNameStepState();
}

class _CTOrganizationNameStepState extends State<CTOrganizationNameStep> {
  late final TextEditingController _organizationController;

  @override
  void initState() {
    super.initState();

    _organizationController = TextEditingController(
      text: widget.journeyController.organization.identity.name,
    );

    _organizationController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _organizationController.removeListener(_onTextChanged);
    _organizationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CTJourneyProgress(
                  journeyTitle: 'Organization Setup',
                  currentStep: 2,
                  totalSteps: 7,
                ),

                const SizedBox(height: 18),

                CTJourneyHeader(
                  title: 'Hello ${widget.journeyController.firstName}',
                  question: "What's the name of your organization?",
                  subtitle:
                      'This will become the home for your people, teams, locations, volunteers, and mission.',
                  icon: Icons.business_outlined,
                ),

                const SizedBox(height: 18),

                CTJourneyTextField(
                  controller: _organizationController,
                  hintText: 'Enter organization name',
                  prefixIcon: Icons.business_outlined,
                ),

                const SizedBox(height: 18),

                const CTJourneyInfoCard(
                  icon: Icons.info_outline_rounded,
                  title: 'Your organization can always evolve.',
                  message:
                      'Choose the name people know you by today. You can always update it later in Organization Settings.',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onBack,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: const Text('Back'),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: CTJourneyButton(
                text: 'Continue',
                onPressed: _organizationController.text.trim().isEmpty
                    ? null
                    : () {
                        widget.journeyController.updateOrganizationName(
                          _organizationController.text.trim(),
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
