import 'package:flutter/material.dart';

class CreateGroupStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CreateGroupStepper({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  static const _mediumLabels = [
    'Definition',
    'Members',
    'Associations',
    'Permissions',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final compact = width < 650;
          final medium = width < 1200;

          return Row(
            children: List.generate(steps.length, (index) {
              final active = index == currentStep;
              final complete = index < currentStep;

              final label = medium && index < _mediumLabels.length
                  ? _mediumLabels[index]
                  : steps[index];

              return Expanded(
                child: Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: complete
                              ? const Color(0xFF06B6D4)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                    Container(
                      width: compact ? 28 : 32,
                      height: compact ? 28 : 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: active || complete
                            ? const Color(0xFF06B6D4)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: complete
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: active
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                    ),
                    if (!compact) ...[
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: active
                                ? const Color(0xFF06B6D4)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
