/// Represents a person within an organization.
///
/// A person may serve in many roles,
/// belong to multiple groups,
/// and work across multiple workspaces.
///
/// ChariTask models people first.
/// Roles, permissions, and responsibilities are assigned
/// separately so a person's identity remains consistent.
class Person {
  /// Unique identifier.
  final String id;

  /// Basic identity.
  final String firstName;
  final String lastName;
  final String? preferredName;

  /// Contact information.
  final String? email;
  final String? phone;

  /// Optional profile photo.
  final String? photoPath;

  const Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.preferredName,
    this.email,
    this.phone,
    this.photoPath,
  });

  /// Full legal/display name.
  String get fullName => '$firstName $lastName';

  /// Preferred display name.
  String get displayName {
    if (preferredName != null && preferredName!.trim().isNotEmpty) {
      return preferredName!;
    }

    return fullName;
  }

  Person copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? preferredName,
    String? email,
    String? phone,
    String? photoPath,
  }) {
    return Person(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      preferredName: preferredName ?? this.preferredName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}
