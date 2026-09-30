/// Assigns a Functional Role to a person within an organization.
///
/// A person may have multiple Functional Role assignments.
/// An assignment may optionally be associated with a workspace.
///
/// Location, Program, and Group context can be added as the
/// assignment architecture expands.
class FunctionalRoleAssignment {
  /// Unique identifier.
  final String id;

  /// Organization that owns the assignment.
  final String organizationId;

  /// Person receiving the role.
  final String personId;

  /// Functional Role being assigned.
  final String functionalRoleId;

  /// Optional workspace context.
  final String? workspaceId;

  /// Assignment lifecycle status.
  final String status;

  /// When the assignment began.
  final DateTime assignedAt;

  /// When the assignment ended.
  final DateTime? endedAt;

  /// Person who created the assignment.
  final String? createdByPersonId;

  /// Person who last updated the assignment.
  final String? updatedByPersonId;

  /// When the assignment was created.
  final DateTime? createdAt;

  /// When the assignment was last updated.
  final DateTime? updatedAt;

  const FunctionalRoleAssignment({
    required this.id,
    required this.organizationId,
    required this.personId,
    required this.functionalRoleId,
    this.workspaceId,
    this.status = 'active',
    required this.assignedAt,
    this.endedAt,
    this.createdByPersonId,
    this.updatedByPersonId,
    this.createdAt,
    this.updatedAt,
  });

  bool get isActive => status == 'active';

  factory FunctionalRoleAssignment.fromMap(Map<String, dynamic> map) {
    return FunctionalRoleAssignment(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      personId: map['person_id'] as String,
      functionalRoleId: map['functional_role_id'] as String,
      workspaceId: map['workspace_id'] as String?,
      status: map['status'] as String? ?? 'active',
      assignedAt: _parseDate(map['assigned_at']) ?? DateTime.now(),
      endedAt: _parseDate(map['ended_at']),
      createdByPersonId: map['created_by_person_id'] as String?,
      updatedByPersonId: map['updated_by_person_id'] as String?,
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }

  FunctionalRoleAssignment copyWith({
    String? id,
    String? organizationId,
    String? personId,
    String? functionalRoleId,
    String? workspaceId,
    String? status,
    DateTime? assignedAt,
    DateTime? endedAt,
    String? createdByPersonId,
    String? updatedByPersonId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FunctionalRoleAssignment(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      personId: personId ?? this.personId,
      functionalRoleId: functionalRoleId ?? this.functionalRoleId,
      workspaceId: workspaceId ?? this.workspaceId,
      status: status ?? this.status,
      assignedAt: assignedAt ?? this.assignedAt,
      endedAt: endedAt ?? this.endedAt,
      createdByPersonId: createdByPersonId ?? this.createdByPersonId,
      updatedByPersonId: updatedByPersonId ?? this.updatedByPersonId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
