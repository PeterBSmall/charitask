class FunctionalRole {
  final String id;
  final String organizationId;
  final String name;
  final String slug;
  final String? description;
  final String? categoryId;
  final String? categoryName;
  final String? categorySlug;
  final bool isActive;
  final int assignmentCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? archivedAt;
  final String? catalogRoleId;

  const FunctionalRole({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.slug,
    this.description,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    required this.isActive,
    this.assignmentCount = 0,
    this.createdAt,
    this.updatedAt,
    this.archivedAt,
    this.catalogRoleId,
  });

  factory FunctionalRole.fromMap(Map<String, dynamic> map) {
    final category = map['functional_role_categories'];

    return FunctionalRole(
      id: map['id'] as String,
      organizationId: map['organization_id'] as String,
      name: map['name'] as String,
      slug: map['slug'] as String,
      description: map['description'] as String?,
      categoryId: map['category_id'] as String?,
      categoryName: category is Map<String, dynamic>
          ? category['name'] as String?
          : null,
      categorySlug: category is Map<String, dynamic>
          ? category['slug'] as String?
          : null,
      isActive: map['status'] == 'active',
      assignmentCount: (map['assignment_count'] as num?)?.toInt() ?? 0,
      createdAt: _parseDateTime(map['created_at']),
      updatedAt: _parseDateTime(map['updated_at']),
      archivedAt: _parseDateTime(map['archived_at']),
      catalogRoleId: map['catalog_role_id'] as String?,
    );
  }

  bool get isImported => catalogRoleId != null;

  FunctionalRole copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? slug,
    String? description,
    String? categoryId,
    String? categoryName,
    String? categorySlug,
    bool? isActive,
    int? assignmentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? archivedAt,
    String? catalogRoleId,
  }) {
    return FunctionalRole(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categorySlug: categorySlug ?? this.categorySlug,
      isActive: isActive ?? this.isActive,
      assignmentCount: assignmentCount ?? this.assignmentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      catalogRoleId: catalogRoleId ?? this.catalogRoleId,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
