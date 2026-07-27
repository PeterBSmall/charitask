import 'package:flutter/material.dart';

import '../../models/ct_workspace_module.dart';
import 'ct_workspace_module_tile.dart';
import 'ct_workspace_section.dart';

class CTWorkspaceModules extends StatelessWidget {
  final String title;
  final List<CTWorkspaceModule> modules;

  const CTWorkspaceModules({
    super.key,
    required this.modules,
    this.title = 'Foundation Modules',
  });

  @override
  Widget build(BuildContext context) {
    return CTWorkspaceSection(
      title: title,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 20.0;

          final tileWidth = (constraints.maxWidth - spacing) / 2;

          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: modules
                .map(
                  (module) => SizedBox(
                    width: tileWidth,
                    child: CTWorkspaceModuleTile(
                      icon: module.icon,
                      title: module.title,
                      subtitle: module.subtitle,
                      progress: module.progress,
                      color: module.color,
                      onTap: module.onTap,
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
