import 'package:flutter/material.dart';

class AddPersonStepper extends StatelessWidget {
  const AddPersonStepper({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  final int currentStep;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16 : 24,
            vertical: isCompact ? 16 : 20,
          ),
          child: isCompact ? _buildCompactStepper() : _buildDesktopStepper(),
        );
      },
    );
  }

  Widget _buildDesktopStepper() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStepCircle(
                      index: index,
                      isActive: isActive,
                      isCompleted: isCompleted,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      steps[index],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.25,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive
                            ? const Color(0xFF5B4BC4)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Container(
                      height: 2,
                      color: index < currentStep
                          ? const Color(0xFF5B4BC4)
                          : const Color(0xFFD1D5DB),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCompactStepper() {
    final safeCurrentStep = currentStep.clamp(0, steps.length - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = constraints.maxWidth < 180 ? 24.0 : 32.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: List.generate(steps.length * 2 - 1, (index) {
                if (index.isOdd) {
                  final stepBefore = index ~/ 2;

                  return Expanded(
                    child: Container(
                      height: 2,
                      color: stepBefore < safeCurrentStep
                          ? const Color(0xFF5B4BC4)
                          : const Color(0xFFD1D5DB),
                    ),
                  );
                }

                final stepIndex = index ~/ 2;
                final isActive = stepIndex == safeCurrentStep;
                final isCompleted = stepIndex < safeCurrentStep;

                return _buildStepCircle(
                  index: stepIndex,
                  isActive: isActive,
                  isCompleted: isCompleted,
                  compact: true,
                  size: circleSize,
                );
              }),
            ),
            const SizedBox(height: 12),
            Text(
              'Step ${safeCurrentStep + 1} of ${steps.length}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              steps[safeCurrentStep],
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5B4BC4),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepCircle({
    required int index,
    required bool isActive,
    required bool isCompleted,
    bool compact = false,
    double? size,
  }) {
    final circleSize = size ?? (compact ? 32.0 : 38.0);

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive || isCompleted ? const Color(0xFF5B4BC4) : Colors.white,
        border: Border.all(
          color: isActive || isCompleted
              ? const Color(0xFF5B4BC4)
              : const Color(0xFFD1D5DB),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: isCompleted
          ? Icon(Icons.check, size: compact ? 16 : 18, color: Colors.white)
          : Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: compact ? 13 : 15,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
    );
  }
}
