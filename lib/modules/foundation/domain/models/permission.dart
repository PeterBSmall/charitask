class Permission {
  final String id;
  final String key;
  final String name;
  final String? description;
  final String module;

  const Permission({
    required this.id,
    required this.key,
    required this.name,
    this.description,
    required this.module,
  });

  factory Permission.fromMap(Map<String, dynamic> map) {
    return Permission(
      id: map['id'] as String,
      key: map['key'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      module: map['module'] as String,
    );
  }
}
