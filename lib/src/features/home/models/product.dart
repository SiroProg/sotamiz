class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.priceText,
    required this.imageUrl,
    required this.location,
    required this.createdAt,
    required this.categoryId,
    this.description,
  });

  final String id;
  final String title;
  final int price;
  final String priceText;
  final String? imageUrl;
  final String location;
  final DateTime createdAt;
  final String categoryId;
  final String? description;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      price: (json['price'] is num) ? (json['price'] as num).toInt() : 0,
      priceText: (json['priceText'] ?? json['price']?.toString() ?? '0').toString(),
      imageUrl: (json['imageUrl'] as String?)?.trim().isEmpty == true
          ? null
          : (json['imageUrl'] as String?),
      location: (json['location'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(
            (json['createdAt'] is num) ? (json['createdAt'] as num).toInt() : 0,
          ),
      categoryId: (json['categoryId'] ?? '').toString(),
      description: (json['description'] as String?)?.trim().isEmpty == true
          ? null
          : (json['description'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'priceText': priceText,
      'imageUrl': imageUrl,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'categoryId': categoryId,
      'description': description,
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} д';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ч';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} м';
    } else {
      return 'только что';
    }
  }
}
