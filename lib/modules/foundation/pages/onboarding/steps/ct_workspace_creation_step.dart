import 'package:flutter/material.dart';

import 'package:charitask/domain/mission_profile/mission_profile.dart';

import 'package:charitask/shared/design_system/animations/ct_journey_reveal.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_constants.dart';
import 'package:charitask/shared/design_system/journey/ct_journey_progress.dart';
import 'package:charitask/shared/design_system/animations/ct_loading_indicator.dart';

class CTWorkspaceCreationStep extends StatefulWidget {
  final CTMissionProfile profile;
  final VoidCallback onContinue;
  final VoidCallback onCompleteProfile;

  const CTWorkspaceCreationStep({
    super.key,
    required this.profile,
    required this.onContinue,
    required this.onCompleteProfile,
  });

  @override
  State<CTWorkspaceCreationStep> createState() =>
      _CTWorkspaceCreationStepState();
}

class _CTWorkspaceCreationStepState extends State<CTWorkspaceCreationStep> {
  int _completedItems = 0;

  final List<String> _checklist = const [
    'Organization profile',
    'Mission & organization type',
    'Location',
    'Organization structure',
    'Workspace configuration',
    'Personal profile',
  ];

  @override
  void initState() {
    super.initState();
    _runPreparation();
  }

  Future<void> _runPreparation() async {
    // Give the user a moment to absorb the screen.
    await Future.delayed(const Duration(milliseconds: 700));

    for (int i = 0; i < _checklist.length; i++) {
      if (!mounted) return;

      setState(() {
        _completedItems = i + 1;
      });

      // Let the user clearly see each item complete.
      await Future.delayed(const Duration(milliseconds: 900));
    }

    // IMPORTANT:
    // Stay on this screen after the animation finishes.
    // The user will advance by pressing Continue.
  }

  @override
  Widget build(BuildContext context) {
    return _buildPreparationScreen();
  }

  // ===========================================================================
  // BUILDING SCREEN
  // ===========================================================================

  Widget _buildPreparationScreen() {
    final progress = _completedItems / _checklist.length;
    final isComplete = _completedItems == _checklist.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 6, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

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
                // --------------------------------------------------------------
                // HEADER
                // --------------------------------------------------------------
                Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: isComplete
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

                const SizedBox(height: 28),

                // --------------------------------------------------------------
                // PROGRESS BAR
                // --------------------------------------------------------------
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

                const SizedBox(height: 28),

                // --------------------------------------------------------------
                // CHECKLIST
                // --------------------------------------------------------------
                Column(
                  children: List.generate(_checklist.length, (index) {
                    return _buildChecklistItem(
                      label: _checklist[index],
                      index: index,
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // --------------------------------------------------------------
                // READY MESSAGE
                // --------------------------------------------------------------
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isComplete ? 1 : 0,
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
                            'Your workspace is ready.',
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

                // --------------------------------------------------------------
                // CONTINUE BUTTON
                // --------------------------------------------------------------
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isComplete ? 1 : 0,
                  child: IgnorePointer(
                    ignoring: !isComplete,
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
        ),
      ],
    );
  }

  // ===========================================================================
  // CHECKLIST ITEM
  // ===========================================================================

  Widget _buildChecklistItem({required String label, required int index}) {
    final isComplete = index < _completedItems;
    final isCurrent = index == _completedItems;

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
                    key: ValueKey('complete_$index'),
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
                    key: ValueKey('pending_$index'),
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
              child: Text(label),
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

  // ===========================================================================
  // FINAL COMPLETION SCREEN
  // ===========================================================================

  Widget _buildCompletionScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CTJourneyProgress(currentStep: 7, totalSteps: 7),

        const SizedBox(height: CTJourneySpacing.progressToHeader),

        const Text(
          'Your mission has a home.',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
          ),
        ),

        const SizedBox(height: 28),

        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE5D9FF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFFECE7FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Color(0xFF6C4CF1),
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Organization Workspace Ready',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Your organization is set up and ready to use.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF667085),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What’s next?',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        'Choose something to do now, or go straight to your workspace.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF667085),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _NextActionCard(
                                icon: Icons.person_outline_rounded,
                                title: 'Complete Your Personal Profile',
                                description:
                                    'Add the personal details that represent you in your organization.',
                                onTap: widget.onCompleteProfile,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: _NextActionCard(
                                icon: Icons.people_outline_rounded,
                                title: 'Invite Your Team Members',
                                description:
                                    'Start building your organization’s team.',
                                onTap: () {
                                  // Team invitation
                                  // flow will be
                                  // connected here.
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      const _MoreActionsButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        CTJourneyReveal(
          visible: true,
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.onContinue,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  'Go to Organization Workspace',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// NEXT ACTION CARD
// =============================================================================

class _NextActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _NextActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE3E1EA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0EBFF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF6C4CF1), size: 23),
              ),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF243047),
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 6),

              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF667085),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MORE ACTIONS
// =============================================================================

class _MoreActionsButton extends StatelessWidget {
  const _MoreActionsButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: PopupMenuButton<String>(
        tooltip: 'More actions',
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onSelected: (value) {
          // We'll connect these actions
          // as those flows are built.
        },
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: 'explore',
            child: Text('Explore organization tools'),
          ),
          PopupMenuItem(
            value: 'profile',
            child: Text('Complete organization profile'),
          ),
          PopupMenuItem(
            value: 'project',
            child: Text('Create your first project or event'),
          ),
        ],
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE3E1EA)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.more_horiz_rounded,
                color: Color(0xFF6C4CF1),
                size: 24,
              ),

              SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'More actions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF243047),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Explore more ways to get started',
                      style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
                    ),
                  ],
                ),
              ),

              Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF243047)),
            ],
          ),
        ),
      ),
    );
  }
}
