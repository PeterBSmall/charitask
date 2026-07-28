import 'package:flutter/material.dart';

import 'package:charitask/shared/data/foundation_suite.dart';
import 'package:charitask/shared/design_system/foundations/app_spacing.dart';
import 'package:charitask/shared/widgets/cards/ct_module_card.dart';

class FoundationModules extends StatelessWidget {
  const FoundationModules({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: foundationSuite.modules.map((module) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: CTModuleCard(
            icon: module.icon,
            title: module.title,
            description: module.description,
            onTap: () {
              // Navigation comes next
            },
          ),
        );
      }).toList(),
    );
  }
}
