import 'package:flutter/material.dart';

class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  bool get hasMinimumLength => password.length >= 8;

  bool get hasNumber => RegExp(r'\d').hasMatch(password);

  bool get hasUppercase => RegExp(r'[A-Z]').hasMatch(password);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        _Requirement(
          text: 'At least 8 characters',
          satisfied: hasMinimumLength,
        ),
        _Requirement(text: 'One number', satisfied: hasNumber),
        _Requirement(text: 'One uppercase letter', satisfied: hasUppercase),
      ],
    );
  }
}

class _Requirement extends StatelessWidget {
  final String text;
  final bool satisfied;

  const _Requirement({required this.text, required this.satisfied});

  @override
  Widget build(BuildContext context) {
    final color = satisfied
        ? Colors.green
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_outline_rounded, size: 18, color: color),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
