/// Represents a mission-driven organization.
///
/// Organizations create possibility.
/// Every other object in ChariTask ultimately belongs
/// to an organization.
class Organization {
  final String id;

  final String name;

  final String? legalName;

  final String? mission;

  final String? vision;

  final String? website;

  final String? email;

  final String? phone;

  final String? logoPath;

  const Organization({
    required this.id,
    required this.name,
    this.legalName,
    this.mission,
    this.vision,
    this.website,
    this.email,
    this.phone,
    this.logoPath,
  });

  Organization copyWith({
    String? id,
    String? name,
    String? legalName,
    String? mission,
    String? vision,
    String? website,
    String? email,
    String? phone,
    String? logoPath,
  }) {
    return Organization(
      id: id ?? this.id,
      name: name ?? this.name,
      legalName: legalName ?? this.legalName,
      mission: mission ?? this.mission,
      vision: vision ?? this.vision,
      website: website ?? this.website,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      logoPath: logoPath ?? this.logoPath,
    );
  }
}
