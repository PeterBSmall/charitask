import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_button.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_info_card.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/forms/ct_place_field.dart';
import 'package:charitask/shared/models/ct_place.dart';

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

    _locationController.addListener(_onLocationChanged);
  }

  void _onLocationChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _locationController.removeListener(_onLocationChanged);
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CTJourneyProgress(currentStep: 6, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        CTJourneyHeader(
          title: 'Hello ${widget.journeyController.firstName}.',
          question: 'Where is your organization located?',
          subtitle:
              'Start with your primary location. You can always add more later.',
          icon: Icons.location_on_outlined,
        ),

        const SizedBox(height: 18),

        CTLocationField(
          controller: _locationController,
          onChanged: (CTPlace place) {
            // Google-selected location.
          },
        ),

        const SizedBox(height: 18),

        const CTJourneyInfoCard(
          icon: Icons.info_outline_rounded,
          title: 'Your organization can grow with you.',
          message:
              'Start with your primary location today. Additional offices, campuses, stores, or service areas can be added anytime.',
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onBack,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Back'),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: CTJourneyButton(
                text: 'Continue',
                onPressed: _locationController.text.trim().isEmpty
                    ? null
                    : () {
                        debugPrint(
                          'CTOrganizationLocationStep: Continue pressed '
                          'with location: '
                          '${_locationController.text.trim()}',
                        );

                        widget.journeyController.updateOrganizationLocation(
                          _locationController.text.trim(),
                        );

                        debugPrint(
                          'CTOrganizationLocationStep: '
                          'calling onContinue.',
                        );

                        widget.onContinue();
                      },
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}
