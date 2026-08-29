import 'package:flutter/material.dart';

import 'package:charitask/domain/mission_profile/mission_profile.dart';
import 'package:charitask/shared/design_system/animations/ct_loading_indicator.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';

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
    await Future.delayed(const Duration(milliseconds: 700));

    for (final task in tasks) {
      if (!mounted) return;

      setState(() {
        task.completed = true;
      });

      await Future.delayed(const Duration(milliseconds: 900));
    }

    if (!mounted) return;

    setState(() {
      complete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = tasks.isEmpty
        ? 0.0
        : tasks.where((task) => task.completed).length / tasks.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CTJourneyProgress(currentStep: 6, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F5FF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5D9FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // -------------------------------------------------------------
              // HEADER
              // -------------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: complete
                        ? Container(
                            key: const ValueKey('complete'),
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFECE7FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF6246E5),
                              size: 28,
                            ),
                          )
                        : const SizedBox(
                            key: ValueKey('loading'),
                            width: 48,
                            height: 48,
                            child: Center(child: CTLoadingIndicator()),
                          ),
                  ),

                  const SizedBox(width: 16),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Building your organization workspace',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Setting everything up so you can get started.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6246E5),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // -------------------------------------------------------------
              // PROGRESS BAR
              // -------------------------------------------------------------
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE5DFFF),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF6246E5),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // -------------------------------------------------------------
              // CHECKLIST
              // -------------------------------------------------------------
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  tasks.length,
                  (index) => _PreparationChecklistItem(
                    task: tasks[index],
                    isCurrent:
                        !complete &&
                        !tasks[index].completed &&
                        (index == 0 || tasks[index - 1].completed),
                  ),
                ),
              ),

              // -------------------------------------------------------------
              // READY MESSAGE
              // -------------------------------------------------------------
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: complete ? 1 : 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5D9FF)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF6246E5),
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Your organization workspace is ready.',
                          style: TextStyle(
                            color: Color(0xFF344054),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // -------------------------------------------------------------
              // CONTINUE
              // -------------------------------------------------------------
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: complete ? 1 : 0,
                child: IgnorePointer(
                  ignoring: !complete,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: widget.onContinue,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// PREPARATION CHECKLIST ITEM
// ===========================================================================

class _PreparationChecklistItem extends StatelessWidget {
  final CTPreparationTask task;
  final bool isCurrent;

  const _PreparationChecklistItem({
    required this.task,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = task.completed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isComplete ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isComplete ? const Color(0xFFE8E2FF) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isComplete
                ? Container(
                    key: ValueKey('complete_${task.title}'),
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6246E5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  )
                : Container(
                    key: ValueKey('pending_${task.title}'),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? const Color(0xFFF0ECFF)
                          : const Color(0xFFF5F3FA),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent
                            ? const Color(0xFFB9A8FF)
                            : const Color(0xFFE4E1EB),
                      ),
                    ),
                    child: isCurrent
                        ? const Padding(
                            padding: EdgeInsets.all(6),
                            child: CTLoadingIndicator(),
                          )
                        : null,
                  ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color: isComplete
                    ? const Color(0xFF263248)
                    : const Color(0xFF98A2B3),
                fontSize: 13,
                fontWeight: isComplete ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          if (isComplete)
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF6246E5),
              size: 18,
            ),
        ],
      ),
    );
  }
}
