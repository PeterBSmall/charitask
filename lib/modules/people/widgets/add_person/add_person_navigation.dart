import 'package:flutter/material.dart';

class AddPersonNavigation extends StatelessWidget {
  const AddPersonNavigation({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isCurrentStepValid,
    required this.onBack,
    required this.onNext,
  });

  final int currentStep;
  final int totalSteps;
  final bool isCurrentStepValid;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final isFirstStep = currentStep == 0;
    final isLastStep = currentStep == totalSteps - 1;

    final canProceed = !isLastStep && isCurrentStepValid;

    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE2E5EC))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: isFirstStep ? null : onBack,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
          ),

          ElevatedButton.icon(
            onPressed: canProceed ? onNext : null,

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B4BC4),
              foregroundColor: Colors.white,

              disabledBackgroundColor: const Color(0xFFE5E7EB),
              disabledForegroundColor: const Color(0xFF9CA3AF),

              minimumSize: const Size(145, 48),

              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              elevation: 0,
            ),

            icon: const Icon(Icons.arrow_forward),

            label: const Text(
              'Next',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
