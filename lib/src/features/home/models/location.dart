class Location {
  const Location({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
