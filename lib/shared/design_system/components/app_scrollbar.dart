import 'package:flutter/material.dart';

import '../foundations/app_colors.dart';

class AppScrollbar extends StatelessWidget {
  final Widget child;
  final ScrollController? controller;
  final EdgeInsetsGeometry padding;
  final bool thumbVisibility;
  final bool trackVisibility;

  const AppScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.padding = const EdgeInsets.only(right: 12),
    this.thumbVisibility = true,
    this.trackVisibility = false,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbVisibility: WidgetStateProperty.all(thumbVisibility),
        trackVisibility: WidgetStateProperty.all(trackVisibility),

        thickness: WidgetStateProperty.resolveWith<double>((states) {
          return states.contains(WidgetState.hovered) ? 12 : 10;
        }),

        radius: const Radius.circular(100),

        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          return states.contains(WidgetState.hovered)
              ? AppColors.missionPurple.withValues(alpha: 0.75)
              : AppColors.missionPurple.withValues(alpha: 0.50);
        }),

        trackColor: WidgetStateProperty.all(
          AppColors.missionPurple.withValues(alpha: 0.06),
        ),
      ),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: thumbVisibility,
        trackVisibility: trackVisibility,
        interactive: true,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
