class Baner {
  const Baner({
    required this.id,
    required this.imageUrl,
    this.title,
    this.link,
  });

  final String id;
  final String imageUrl;
  final String? title;
  final String? link;

  factory Baner.fromJson(Map<String, dynamic> json) {
    return Baner(
      id: (json['id'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      title: (json['title'] as String?)?.trim().isEmpty == true
          ? null
          : (json['title'] as String?),
      link: (json['link'] as String?)?.trim().isEmpty == true
          ? null
          : (json['link'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'imageUrl': imageUrl, 'title': title, 'link': link};
  }
}
