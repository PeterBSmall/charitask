/// Organization-owned category for Functional Roles.
class FunctionalRoleCategory {
  /// Unique identifier.
  final String id;

  /// Organization that owns this category.
  final String organizationId;

  /// Display name.
  final String name;

  /// URL/database-safe slug.
  final String slug;

  /// Optional description.
  final String? description;

  /// Display ordering.
  final int sortOrder;

  /// Whether the category is active.
  final bool isActive;

  const FunctionalRoleCategory({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.slug,
    this.description,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory FunctionalRoleCategory.fromMap(Map<String, dynamic> map) {
    return FunctionalRoleCategory(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      name: map['name'] as String,
      slug: map['slug'] as String,
      description: map['description'] as String?,
      sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
      isActive: map['status'] == 'active',
    );
  }

  FunctionalRoleCategory copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? slug,
    String? description,
    int? sortOrder,
    bool? isActive,
  }) {
    return FunctionalRoleCategory(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }
}
