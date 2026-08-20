import 'organization_mission.dart';
import 'organization_size.dart';
import 'organization_type.dart';

/// Represents the canonical organization entity in ChariTask.
///
/// An Organization is the top-level operating entity.
///
/// Workspaces belong to an Organization.
class Organization {
  final String id;
  final String name;

  final OrganizationType type;
  final OrganizationSize size;
  final OrganizationMission mission;

  const Organization({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.mission,
  });
}
