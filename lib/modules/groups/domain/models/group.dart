class Group {
  final String id;
  final String organizationId;
  final String name;
  final String? description;
  final String color;
  final bool isActive;

  const Group({
    required this.id,
    required this.organizationId,
    required this.name,
    this.description,
    this.color = '#5B4BC4',
    this.isActive = true,
  });

  Group copyWith({
    String? id,
    String? organizationId,
    String? name,
    String? description,
    String? color,
    bool? isActive,
  }) {
    return Group(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      description: description,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
    );
  }
}
