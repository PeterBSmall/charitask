import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_info_card.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_textfield.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';

class CTOrganizationLocationStep extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  final CTJourneyController journeyController;

  const CTOrganizationLocationStep({
    super.key,
    required this.journeyController,
    required this.onContinue,
    required this.onBack,
  });
  @override
  State<CTOrganizationLocationStep> createState() =>
      _CTOrganizationLocationStepState();
}

class _CTOrganizationLocationStepState
    extends State<CTOrganizationLocationStep> {
  late final TextEditingController _locationController;

  @override
  void initState() {
    super.initState();

    _locationController = TextEditingController(
      text: widget.journeyController.organizationLocation,
    );

    _locationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 4, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        CTJourneyHeader(
          title: 'Hello Peter.',
          question: 'Where is your organization located?',
          subtitle:
              'This helps us personalize your experience and prepare for future location features.',
          icon: Icons.location_on_outlined,
        ),

        const SizedBox(height: CTJourneySpacing.headerToField),

        CTJourneyTextField(
          controller: _locationController,
          hintText: 'City, State or ZIP Code',
          prefixIcon: Icons.location_on_outlined,
        ),

        const SizedBox(height: 24),

        const CTJourneyInfoCard(
          icon: Icons.info_outline_rounded,
          title: 'You can always add more locations.',
          message:
              'This is simply your primary location. Additional campuses, stores, offices, or sites can be added later.',
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
                onPressed: _locationController.text.trim().isEmpty
                    ? null
                    : () {
                        widget.journeyController.updateOrganizationLocation(
                          _locationController.text.trim(),
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
