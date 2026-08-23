import 'package:flutter/material.dart';

class CTSidebar extends StatelessWidget {
  final Widget header;
  final Widget child;
  final Widget? footer;
  final double width;

  const CTSidebar({
    super.key,
    required this.header,
    required this.child,
    this.footer,
    this.width = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        // Slight cool tint instead of pure white
        color: const Color(0xFFF8F7FD),

        border: Border(
          right: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,

          Expanded(child: child),

          if (footer != null) footer!,
        ],
      ),
    );
  }
}
