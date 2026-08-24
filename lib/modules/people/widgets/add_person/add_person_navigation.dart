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
            onPressed: isLastStep ? null : (isCurrentStepValid ? onNext : null),
            icon: Icon(isLastStep ? Icons.check : Icons.arrow_forward),
            label: Text(isLastStep ? 'Create' : 'Next'),
          ),
        ],
      ),
    );
  }
}
