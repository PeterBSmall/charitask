import 'authorization_relationship_status.dart';

/// Represents a Permission granted through a Permission Tier.
///
/// This relationship connects a Permission Tier to one
/// specific Permission.
///
/// Examples:
///
/// Viewer
///   → people.view
///
/// Manager
///   → people.view
///   → people.edit
///   → schedules.manage
class PermissionTierPermission {
  /// Unique identifier for this relationship episode.
  final String id;

  /// The Permission Tier receiving the Permission.
  final String permissionTierId;

  /// The Permission being granted.
  final String permissionId;

  /// Lifecycle status of this relationship episode.
  final AuthorizationRelationshipStatus status;

  /// When this relationship episode began.
  final DateTime startsAt;

  /// When this relationship episode ended.
  final DateTime? endsAt;

  const PermissionTierPermission({
    required this.id,
    required this.permissionTierId,
    required this.permissionId,
    this.status = AuthorizationRelationshipStatus.active,
    required this.startsAt,
    this.endsAt,
  });

  PermissionTierPermission copyWith({
    String? id,
    String? permissionTierId,
    String? permissionId,
    AuthorizationRelationshipStatus? status,
    DateTime? startsAt,
    DateTime? endsAt,
  }) {
    return PermissionTierPermission(
      id: id ?? this.id,
      permissionTierId: permissionTierId ?? this.permissionTierId,
      permissionId: permissionId ?? this.permissionId,
      status: status ?? this.status,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
    );
  }
}
