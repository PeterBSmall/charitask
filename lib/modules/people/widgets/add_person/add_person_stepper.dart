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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? const Color(0xFF5B4BC4)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),

                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent || isCompleted
                            ? const Color(0xFF5B4BC4)
                            : Colors.white,
                        border: Border.all(
                          color: isCurrent || isCompleted
                              ? const Color(0xFF5B4BC4)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isCurrent
                                      ? Colors.white
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                      ),
                    ),

                    if (index < steps.length - 1)
                      const Expanded(child: SizedBox()),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                    color: isCurrent
                        ? const Color(0xFF5B4BC4)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
