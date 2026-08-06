import 'organization_size.dart';
import 'organization_type.dart';
import 'organization_mission.dart';

class OrganizationIdentity {
  String id;
  String name;

  OrganizationType type;
  OrganizationSize size;

  OrganizationMission mission;

  OrganizationIdentity({
    this.id = '',
    this.name = '',
    this.type = OrganizationType.nonprofit,
    this.size = OrganizationSize.startup,
    this.mission = OrganizationMission.communityService,
  });
}
