import 'authorization_relationship_status.dart';

/// Represents a Permission granted through a Functional Role.
///
/// This relationship connects a Functional Role to one
/// specific Permission.
///
/// Examples:
///
/// Scheduler
///   → schedules.view
///   → schedules.manage
///
/// Cashier
///   → sales.create
///   → sales.view
class FunctionalRolePermission {
  /// Unique identifier for this relationship episode.
  final String id;

  /// The Functional Role receiving the Permission.
  final String functionalRoleId;

  /// The Permission being granted.
  final String permissionId;

  /// Lifecycle status of this relationship episode.
  final AuthorizationRelationshipStatus status;

  /// When this relationship episode began.
  final DateTime startsAt;

  /// When this relationship episode ended.
  final DateTime? endsAt;

  const FunctionalRolePermission({
    required this.id,
    required this.functionalRoleId,
    required this.permissionId,
    this.status = AuthorizationRelationshipStatus.active,
    required this.startsAt,
    this.endsAt,
  });

  FunctionalRolePermission copyWith({
    String? id,
    String? functionalRoleId,
    String? permissionId,
    AuthorizationRelationshipStatus? status,
    DateTime? startsAt,
    DateTime? endsAt,
  }) {
    return FunctionalRolePermission(
      id: id ?? this.id,
      functionalRoleId: functionalRoleId ?? this.functionalRoleId,
      permissionId: permissionId ?? this.permissionId,
      status: status ?? this.status,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
    );
  }
}
