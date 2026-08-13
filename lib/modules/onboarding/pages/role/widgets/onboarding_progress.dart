import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  final int currentStep;

  const OnboardingProgress({super.key, required this.currentStep});

  static const _purple = Color(0xFF5633D8);
  static const _darkText = Color(0xFF182238);
  static const _mutedText = Color(0xFF687286);
  static const _line = Color(0xFFDDE1EA);

  static const _steps = [
    (Icons.person_outline_rounded, 'Create Account'),
    (Icons.mail_outline_rounded, 'Verify Email'),
    (Icons.person_rounded, 'Your Role'),
    (Icons.business_outlined, 'Organization'),
    (Icons.grid_view_rounded, 'Workspace'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color: index ~/ 2 < currentStep ? _purple : _line,
            ),
          );
        }

        final stepIndex = index ~/ 2;
        final step = _steps[stepIndex];

        final completed = stepIndex < currentStep;
        final active = stepIndex == currentStep;

        return SizedBox(
          width: 112,
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? Colors.white
                      : completed
                      ? const Color(0xFFF5F1FF)
                      : Colors.white,
                  border: Border.all(
                    color: active || completed ? _purple : _line,
                    width: active ? 2 : 1.5,
                  ),
                ),
                child: Icon(
                  completed ? Icons.check_rounded : step.$1,
                  color: active || completed ? _purple : _mutedText,
                  size: 23,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                step.$2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: active || completed ? _purple : _mutedText,
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
