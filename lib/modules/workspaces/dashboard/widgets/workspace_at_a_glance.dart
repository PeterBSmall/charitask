import 'package:flutter/material.dart';

import 'at_a_glance/tasks_glance_card.dart';
import 'at_a_glance/events_glance_card.dart';
import 'at_a_glance/volunteers_glance_card.dart';
import 'at_a_glance/groups_glance_card.dart';

class WorkspaceAtAGlance extends StatelessWidget {
  final Color accentColor;

  const WorkspaceAtAGlance({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E7EF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.dashboard_customize_outlined,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workspace At a Glance',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17204D),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'A quick look at what is happening across your workspace.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF68738A)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;

              final columns = constraints.maxWidth < 900 ? 2 : 4;

              final cardWidth =
                  (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: TasksGlanceCard(accentColor: accentColor),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: EventsGlanceCard(accentColor: accentColor),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: VolunteersGlanceCard(accentColor: accentColor),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: GroupsGlanceCard(accentColor: accentColor),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
