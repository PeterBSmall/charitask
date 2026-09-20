class CTTask {
  final String id;
  final String organizationId;
  final String workspaceId;
  final String title;
  final String? description;
  final String? assignedToPersonId;
  final String? createdByPersonId;
  final DateTime? dueAt;
  final String status;
  final String priority;
  final DateTime? completedAt;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CTTask({
    required this.id,
    required this.organizationId,
    required this.workspaceId,
    required this.title,
    this.description,
    this.assignedToPersonId,
    this.createdByPersonId,
    this.dueAt,
    required this.status,
    required this.priority,
    this.completedAt,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CTTask.fromMap(Map<String, dynamic> map) {
    return CTTask(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      workspaceId: map['workspace_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      assignedToPersonId: map['assigned_to_person_id'] as String?,
      createdByPersonId: map['created_by_person_id'] as String?,
      dueAt: map['due_at'] == null
          ? null
          : DateTime.parse(map['due_at'] as String),
      status: map['status'] as String,
      priority: map['priority'] as String,
      completedAt: map['completed_at'] == null
          ? null
          : DateTime.parse(map['completed_at'] as String),
      archivedAt: map['archived_at'] == null
          ? null
          : DateTime.parse(map['archived_at'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  bool get isOpen =>
      status == 'open' || status == 'in_progress';

  bool get isCompleted => status == 'completed';

  bool get isCancelled => status == 'cancelled';

  bool get isArchived => archivedAt != null;
}
