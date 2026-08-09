import 'dart:math' as math;

import 'package:flutter/material.dart';

class CTLoadingIndicator extends StatefulWidget {
  final double size;
  final Color color;

  const CTLoadingIndicator({
    super.key,
    this.size = 22,
    this.color = const Color(0xFF6C4CF1),
  });

  @override
  State<CTLoadingIndicator> createState() => _CTLoadingIndicatorState();
}

class _CTLoadingIndicatorState extends State<CTLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Icon(Icons.sync, size: widget.size, color: widget.color),
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * math.pi * 2,
          child: child,
        );
      },
    );
  }
}
