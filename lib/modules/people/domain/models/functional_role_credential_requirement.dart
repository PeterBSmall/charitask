import 'package:charitask/modules/people/domain/models/person_credential.dart';

/// A credential requirement configured for an organization's Functional Role.
class FunctionalRoleCredentialRequirement {
  final String id;
  final String organizationId;
  final String functionalRoleId;
  final CredentialCategory category;
  final String? credentialName;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FunctionalRoleCredentialRequirement({
    required this.id,
    required this.organizationId,
    required this.functionalRoleId,
    required this.category,
    this.credentialName,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory FunctionalRoleCredentialRequirement.fromMap(
    Map<String, dynamic> map,
  ) {
    return FunctionalRoleCredentialRequirement(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      functionalRoleId: map['functional_role_id'] as String,
      category: CredentialCategory.fromValue(map['credential_category']),
      credentialName: map['credential_name'] as String?,
      description: map['description'] as String?,
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }

  /// A category-only requirement accepts any matching credential
  /// category. A named requirement must also match credentialName.
  bool matchesCredential({
    required CredentialCategory credentialCategory,
    required String credentialName,
  }) {
    if (category != credentialCategory) {
      return false;
    }

    final requiredName = this.credentialName?.trim();

    if (requiredName == null || requiredName.isEmpty) {
      return true;
    }

    return requiredName.toLowerCase() == credentialName.trim().toLowerCase();
  }

  static DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
