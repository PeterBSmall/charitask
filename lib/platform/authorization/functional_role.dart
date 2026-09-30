/// Describes the work a person performs.
///
/// Functional Roles define a person's responsibilities,
/// skills, or contributions within the organization.
///
/// A person may have multiple Functional Roles at the
/// same time.
class FunctionalRole {
  /// Unique identifier.
  final String id;

  /// Organization that owns this role.
  final String organizationId;

  /// Display name.
  final String name;

  /// URL/database-safe slug.
  final String slug;

  /// Optional description.
  final String? description;

  /// Functional Role category.
  final String? categoryId;

  /// Category name when loaded with the role.
  final String? categoryName;

  /// Category slug when loaded with the role.
  final String? categorySlug;

  /// Whether the role is active.
  final bool isActive;

  /// Number of people currently assigned this role.
  final int assignmentCount;

  /// When the role was created.
  final DateTime? createdAt;

  /// When the role was last updated.
  final DateTime? updatedAt;

  /// When the role was archived.
  final DateTime? archivedAt;

  const FunctionalRole({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.slug,
    this.description,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.isActive = true,
    this.assignmentCount = 0,
    this.createdAt,
    this.updatedAt,
    this.archivedAt,
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
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
      archivedAt: _parseDate(map['archived_at']),
    );
  }

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
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
