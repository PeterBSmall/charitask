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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Scale the progress indicator down as the window gets smaller.
        final compact = width < 700;
        final veryCompact = width < 520;

        final circleSize = veryCompact
            ? 38.0
            : compact
            ? 42.0
            : 48.0;

        final iconSize = veryCompact
            ? 19.0
            : compact
            ? 21.0
            : 23.0;

        final labelSize = veryCompact
            ? 10.0
            : compact
            ? 11.0
            : 12.0;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(_steps.length * 2 - 1, (index) {
            // ------------------------------------------------------------
            // CONNECTING LINE
            // ------------------------------------------------------------
            if (index.isOdd) {
              return Expanded(
                child: Padding(
                  // Give the line a little breathing room on compact sizes.
                  padding: EdgeInsets.only(
                    top: circleSize / 2,
                    left: compact ? 4 : 8,
                    right: compact ? 4 : 8,
                  ),
                  child: Container(
                    height: 2,
                    color: index ~/ 2 < currentStep ? _purple : _line,
                  ),
                ),
              );
            }

            // ------------------------------------------------------------
            // STEP
            // ------------------------------------------------------------
            final stepIndex = index ~/ 2;
            final step = _steps[stepIndex];

            final completed = stepIndex < currentStep;
            final active = stepIndex == currentStep;

            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: circleSize,
                    height: circleSize,
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
                      size: iconSize,
                    ),
                  ),

                  SizedBox(height: compact ? 5 : 7),

                  // FittedBox prevents long labels from overflowing
                  // when the window becomes narrow.
                  SizedBox(
                    height: veryCompact ? 28 : 32,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        step.$2,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          color: active || completed ? _purple : _mutedText,
                          fontSize: labelSize,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
