import 'package:flutter/material.dart';

import 'package:charitask/domain/mission_profile/mission_profile.dart';

import 'package:charitask/shared/design_system/animations/ct_journey_reveal.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_header.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';
import 'package:charitask/shared/design_system/journey/preparation/ct_preparation_checklist.dart';
import 'package:charitask/shared/design_system/journey/preparation/ct_preparation_task.dart';
import 'package:charitask/shared/design_system/animations/ct_loading_indicator.dart';

class CTWorkspaceCreationStep extends StatefulWidget {
  final CTMissionProfile profile;
  final VoidCallback onContinue;

  const CTWorkspaceCreationStep({
    super.key,
    required this.profile,
    required this.onContinue,
  });

  @override
  State<CTWorkspaceCreationStep> createState() =>
      _CTWorkspaceCreationStepState();
}

class _CTWorkspaceCreationStepState extends State<CTWorkspaceCreationStep> {
  late final List<CTPreparationTask> tasks;

  bool complete = false;

  @override
  void initState() {
    super.initState();

    tasks = widget.profile.workspaceTasks
        .map((title) => CTPreparationTask(title: title))
        .toList();

    _runPreparation();
  }

  Future<void> _runPreparation() async {
    const delays = [700, 1100, 900, 1200, 800, 1400];

    for (int i = 0; i < tasks.length; i++) {
      await Future.delayed(Duration(milliseconds: delays[i]));

      if (!mounted) return;

      setState(() {
        tasks[i].completed = true;
      });
    }

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      complete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 7, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        const CTJourneyHeader(
          title: 'Creating Your Workspace',
          question: '',
          subtitle: '',
          icon: Icons.auto_awesome,
        ),

        const SizedBox(height: 32),

        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE5D9FF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    complete
                        ? const Icon(
                            Icons.check_circle,
                            color: Color(0xFF6C4CF1),
                            size: 22,
                          )
                        : const CTLoadingIndicator(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Building Your Workspace',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.profile.workspaceSubtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: complete
                        ? const _WorkspaceReadyPanel(key: ValueKey('ready'))
                        : CTPreparationChecklist(
                            key: const ValueKey('checklist'),
                            tasks: tasks,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        CTJourneyReveal(
          visible: complete,
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onContinue,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('Continue', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkspaceReadyPanel extends StatelessWidget {
  const _WorkspaceReadyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 48, color: Color(0xFF6C4CF1)),
            SizedBox(height: 20),
            Text(
              'Workspace Ready',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C4CF1),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Everything has been personalized\nfor your organization.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
