import 'organization_type.dart';

class OrganizationIdentity {
  String id;
  String name;
  OrganizationType type;
  String mission;

  OrganizationIdentity({
    this.id = '',
    this.name = '',
    this.type = OrganizationType.nonprofit,
    this.mission = '',
  });
}
