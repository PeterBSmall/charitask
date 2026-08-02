import 'organization_identity.dart';

class Organization {
  final OrganizationIdentity identity;

  Organization({OrganizationIdentity? identity})
    : identity = identity ?? OrganizationIdentity();
}
