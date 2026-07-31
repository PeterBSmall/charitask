import '../decision_result.dart';
import '../workspace_context.dart';
import 'package:flutter/material.dart';
import '../unlock_item.dart';

class FoundationEvaluator {
  const FoundationEvaluator();

  DecisionResult evaluate(WorkspaceContext context) {
    if (context.locations.isEmpty) {
      return const DecisionResult(
        greeting: 'Good Morning, Peter',

        summary:
            'Your organization is making great progress. Here is today\'s focus.',

        title: "Today's Briefing",

        recommendation: 'Create Your First Location',

        explanation:
            'Locations are the foundation for assigning people, volunteers, schedules, and resources.',

        priority: DecisionPriority.normal,

        estimatedTime: '2 minutes',

        unlocks: const [
          UnlockItem(
            icon: Icons.people,
            title: 'People',
            description: 'Manage employees and volunteers.',
          ),
          UnlockItem(
            icon: Icons.calendar_month,
            title: 'Scheduling',
            description: 'Coordinate people and projects.',
          ),
          UnlockItem(
            icon: Icons.inventory_2_outlined,
            title: 'Resources',
            description: 'Track equipment and shared assets.',
          ),
          UnlockItem(
            icon: Icons.analytics_outlined,
            title: 'Reporting',
            description: 'Measure progress and organizational impact.',
          ),
        ],

        progress: 0.33,

        progressLabel: '1 of 3 Foundation Steps Complete',
      );
    }

    if (context.groups.isEmpty) {
      return const DecisionResult(
        title: 'What Matters Now',
        recommendation: 'Create your first group.',
        explanation:
            'Groups organize people into teams, departments, ministries, committees, or volunteer teams.',

        priority: DecisionPriority.high,
        estimatedTime: '2 minutes',

        unlocks: const [
          UnlockItem(
            icon: Icons.groups_outlined,
            title: 'Teams',
            description:
                'Organize employees and volunteers into meaningful groups.',
          ),
          UnlockItem(
            icon: Icons.calendar_month_outlined,
            title: 'Group Scheduling',
            description: 'Schedule entire teams instead of individual people.',
          ),
          UnlockItem(
            icon: Icons.badge_outlined,
            title: 'Roles',
            description:
                'Assign responsibilities and permissions more effectively.',
          ),
          UnlockItem(
            icon: Icons.forum_outlined,
            title: 'Communication',
            description: 'Keep departments and volunteer teams connected.',
          ),
        ],
      );
    }

    if (context.roles.isEmpty) {
      return const DecisionResult(
        title: 'What Matters Now',
        recommendation: 'Create your first organizational role.',
        explanation:
            'Roles define responsibilities and permissions throughout the organization.',
      );
    }

    return const DecisionResult(
      title: 'Foundation Complete',
      recommendation: 'Your organization is ready to grow.',
      explanation: 'Your core organizational structure has been established.',
    );
  }
}
