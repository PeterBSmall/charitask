import 'package:flutter/material.dart';

class WorkspaceCanvas extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const WorkspaceCanvas({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(32),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF35206F), Color(0xFF4B2A8A), Color(0xFF2D1B5A)],
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1440),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
