class ProductCategory {
  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final String icon; 

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      icon: (json['icon'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
