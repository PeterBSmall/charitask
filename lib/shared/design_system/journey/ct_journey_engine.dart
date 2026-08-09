import 'package:flutter/material.dart';

import 'package:charitask/shared/design_system/journey/ct_journey_card.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_chapter.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_controller.dart';
import 'package:charitask/shared/design_system/hero/ct_hero.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_shell.dart';

typedef CTJourneyStepBuilder =
    Widget Function(
      CTJourneyController controller,
      VoidCallback next,
      VoidCallback back,
    );

class CTJourneyEngine extends StatefulWidget {
  final CTJourneyController controller;
  final List<CTJourneyChapter> chapters;
  final List<CTJourneyStepBuilder> steps;

  const CTJourneyEngine({
    super.key,
    required this.controller,
    required this.chapters,
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
        _updateChapterHero();
      });
    }
  }

  void _back() {
    if (widget.controller.currentStep > 0) {
      setState(() {
        widget.controller.previousStep();
        _updateChapterHero();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapters[widget.controller.currentStep];

    return CTJourneyShell(
      leftPanel: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return CTHero(hero: widget.controller.currentHero);
        },
      ),
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

  void _updateChapterHero() {
    widget.controller.setChapterHero(
      widget.chapters[widget.controller.currentStep].hero,
    );

    widget.controller.setContextHero(null);
  }

  @override
  void initState() {
    super.initState();
    _updateChapterHero();
  }
}
