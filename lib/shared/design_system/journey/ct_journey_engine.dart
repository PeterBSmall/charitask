import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_card.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_photo.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_shell.dart';

typedef CTJourneyStepBuilder =
    Widget Function(
      CTJourneyController controller,
      VoidCallback next,
      VoidCallback back,
    );

class CTJourneyEngine extends StatefulWidget {
  final CTJourneyController controller;
  final ImageProvider photo;
  final List<CTJourneyStepBuilder> steps;

  const CTJourneyEngine({
    super.key,
    required this.controller,
    required this.photo,
    required this.steps,
  });

  @override
  State<CTJourneyEngine> createState() => _CTJourneyEngineState();
}

class _CTJourneyEngineState extends State<CTJourneyEngine> {
  void _next() {
    if (widget.controller.currentStep < widget.steps.length - 1) {
      setState(() {
        widget.controller.nextStep();
      });
    }
  }

  void _back() {
    if (widget.controller.currentStep > 0) {
      setState(() {
        widget.controller.previousStep();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CTJourneyShell(
      leftPanel: CTJourneyPhoto(image: widget.photo),
      rightPanel: CTJourneyCard(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.steps[widget.controller.currentStep](
            widget.controller,
            _next,
            _back,
          ),
        ),
      ),
    );
  }
}
