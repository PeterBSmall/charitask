import 'package:flutter/material.dart';

class CreateGroupFooter extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool canContinue;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const CreateGroupFooter({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.canContinue,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final lastStep = currentStep == totalSteps - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            TextButton(
              onPressed: onBack,
              child: Text(currentStep == 0 ? 'Cancel' : 'Back'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: canContinue ? onContinue : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                disabledForegroundColor: const Color(0xFF94A3B8),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                lastStep ? 'Create Group' : 'Continue',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
