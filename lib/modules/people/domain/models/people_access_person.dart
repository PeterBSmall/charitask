class PeopleAccessPerson {
  final String id;
  final String organizationId;
  final String firstName;
  final String lastName;
  final String? preferredName;
  final String? email;
  final String? phone;
  final String? role;
  final String? groups;
  final String? locations;

  const PeopleAccessPerson({
    required this.id,
    required this.organizationId,
    required this.firstName,
    required this.lastName,
    this.preferredName,
    this.email,
    this.phone,
    this.role,
    this.groups,
    this.locations,
  });

  String get displayName {
    final preferred = preferredName?.trim();

    if (preferred != null && preferred.isNotEmpty) {
      return '$preferred $lastName'.trim();
    }

    return '$firstName $lastName'.trim();
  }

  factory PeopleAccessPerson.fromMap(Map<String, dynamic> map) {
    return PeopleAccessPerson(
      id: map['id']?.toString() ?? '',
      organizationId: map['organization_id']?.toString() ?? '',
      firstName: map['first_name']?.toString() ?? '',
      lastName: map['last_name']?.toString() ?? '',
      preferredName: map['preferred_name']?.toString(),
      email: map['email']?.toString(),
      phone: map['phone']?.toString(),
      role: map['role']?.toString(),
      groups: map['groups']?.toString(),
      locations: map['locations']?.toString(),
    );
  }
}
