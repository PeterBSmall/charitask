import 'package:flutter/material.dart';

import 'package:charitask/domain/mission_profile/mission_profile.dart';

import 'ct_preparation_checklist.dart';
import 'ct_preparation_task.dart';

class CTWorkspacePreparationStep extends StatefulWidget {
  final CTMissionProfile profile;
  final VoidCallback onContinue;

  const CTWorkspacePreparationStep({
    super.key,
    required this.profile,
    required this.onContinue,
  });

  @override
  State<CTWorkspacePreparationStep> createState() =>
      _CTWorkspacePreparationStepState();
}

class _CTWorkspacePreparationStepState
    extends State<CTWorkspacePreparationStep> {
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
    for (final task in tasks) {
      await Future.delayed(const Duration(milliseconds: 350));

      if (!mounted) return;

      setState(() {
        task.completed = true;
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      complete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.profile.workspaceTitle,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          Text(
            widget.profile.workspaceSubtitle,
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),

          const SizedBox(height: 40),

          CTPreparationChecklist(tasks: tasks),

          const Spacer(),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: complete
                ? Column(
                    key: const ValueKey('ready'),
                    children: [
                      const Divider(height: 40),

                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, color: Color(0xFF6C4CF1)),
                          SizedBox(width: 8),
                          Text(
                            'Workspace Ready',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C4CF1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Everything has been personalized\nfor your organization.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: widget.onContinue,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            child: Text(
                              'Claim My Workspace',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
