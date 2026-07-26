import 'package:flutter/material.dart';

import '../../models/ct_workspace_task.dart';
import 'ct_workspace_section.dart';
import 'ct_workspace_task_tile.dart';

class CTWorkspaceTasks extends StatelessWidget {
  final List<CTWorkspaceTask> tasks;

  const CTWorkspaceTasks({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return CTWorkspaceSection(
      title: 'Active Tasks',
      actionLabel: 'View All',
      onActionPressed: () {},

      child: Column(
        children: tasks
            .map(
              (task) => CTWorkspaceTaskTile(
                icon: task.icon,
                title: task.title,
                category: task.category,
                color: task.color,
                onTap: task.onTap,
              ),
            )
            .toList(),
      ),
    );
  }
}
