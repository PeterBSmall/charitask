import '../decision_result.dart';
import '../workspace_context.dart';

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

        benefits: [
          'People',
          'Volunteer Scheduling',
          'Resource Planning',
          'Reporting',
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

        benefits: [
          'Organize people into teams',
          'Enable scheduling by group',
          'Assign roles more effectively',
          'Improve communication',
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
