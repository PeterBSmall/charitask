import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'ct_page_header.dart';

class CTPage extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;

  const CTPage({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final bool showHeader = title != null && title!.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader) ...[
                    CTPageHeader(
                      title: title!,
                      subtitle: subtitle ?? '',
                      trailing: trailing,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
