import 'package:flutter/material.dart';

import 'ct_journey_card.dart';
import 'ct_journey_photo.dart';
import 'ct_journey_shell.dart';

class CTJourneyController extends StatefulWidget {
  final List<Widget Function(VoidCallback next, VoidCallback back)> steps;
  final ImageProvider photo;
  final VoidCallback? onComplete;

  const CTJourneyController({
    super.key,
    required this.steps,
    required this.photo,
    this.onComplete,
  });

  @override
  State<CTJourneyController> createState() => _CTJourneyControllerState();
}

class _CTJourneyControllerState extends State<CTJourneyController> {
  int _currentStep = 0;

  void next() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      widget.onComplete?.call();
    }
  }

  void back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CTJourneyShell(
      leftPanel: CTJourneyPhoto(image: widget.photo),
      rightPanel: CTJourneyCard(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.steps[_currentStep](next, back),
        ),
      ),
    );
  }
}
