class Group {
  final String id;
  final String organizationId;
  final String name;
  final String? description;
  final bool isActive;

  const Group({
    required this.id,
    required this.organizationId,
    required this.name,
    this.description,
    this.isActive = true,
  });

  Group copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return Group(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
