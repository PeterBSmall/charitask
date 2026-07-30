class DecisionResult {
  final String greeting;
  final String summary;

  final String title;
  final String recommendation;
  final String explanation;

  final DecisionPriority priority;

  final String estimatedTime;

  final List<String> benefits;

  final double progress;

  final String progressLabel;

  const DecisionResult({
    this.greeting = '',
    this.summary = '',

    required this.title,
    required this.recommendation,
    required this.explanation,

    this.priority = DecisionPriority.normal,
    this.estimatedTime = '',
    this.benefits = const [],

    this.progress = 0,
    this.progressLabel = '',
  });
}

enum DecisionPriority { low, normal, high }
