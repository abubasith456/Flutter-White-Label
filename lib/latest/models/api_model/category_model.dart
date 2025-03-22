class Category {
  final String id;
  final String name;
  final String image;
  final String link;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.link,
  });

  // Factory constructor to create Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      link: json['link'],
    );
  }
}
