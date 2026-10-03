import 'package:flutter/material.dart';

class AddPersonNavigation extends StatelessWidget {
  const AddPersonNavigation({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isCurrentStepValid,
    required this.onBack,
    required this.onNext,
    required this.onCreate,
  });

  final int currentStep;
  final int totalSteps;
  final bool isCurrentStepValid;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final isFirstStep = currentStep == 0;
    final isLastStep = currentStep == totalSteps - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFE2E5EC))),
          ),
          child: isCompact
              ? _buildCompactNavigation(
                  isFirstStep: isFirstStep,
                  isLastStep: isLastStep,
                )
              : _buildDesktopNavigation(
                  isFirstStep: isFirstStep,
                  isLastStep: isLastStep,
                ),
        );
      },
    );
  }

  Widget _buildDesktopNavigation({
    required bool isFirstStep,
    required bool isLastStep,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBackButton(isFirstStep),
        _buildPrimaryButton(isLastStep),
      ],
    );
  }

  Widget _buildCompactNavigation({
    required bool isFirstStep,
    required bool isLastStep,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBackButton(isFirstStep, fullWidth: true),
        const SizedBox(height: 10),
        _buildPrimaryButton(isLastStep, fullWidth: true),
      ],
    );
  }

  Widget _buildBackButton(bool isFirstStep, {bool fullWidth = false}) {
    return OutlinedButton.icon(
      onPressed: isFirstStep ? null : onBack,
      icon: const Icon(Icons.arrow_back),
      label: const Text('Back'),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(fullWidth ? double.infinity : 0, 48),
      ),
    );
  }

  Widget _buildPrimaryButton(bool isLastStep, {bool fullWidth = false}) {
    final canProceed = isCurrentStepValid;

    return ElevatedButton.icon(
      onPressed: canProceed ? (isLastStep ? onCreate : onNext) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5B4BC4),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFE5E7EB),
        disabledForegroundColor: const Color(0xFF9CA3AF),
        minimumSize: Size(fullWidth ? double.infinity : 160, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      icon: Icon(isLastStep ? Icons.check_rounded : Icons.arrow_forward),
      label: Text(
        isLastStep ? 'Create Person' : 'Next',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
