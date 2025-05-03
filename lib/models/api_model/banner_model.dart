class HomeBanner {
  final String id;
  final String title;
  final String image;
  final String link;
  final bool isActive;

  HomeBanner({
    required this.id,
    required this.title,
    required this.image,
    required this.link,
    required this.isActive,
  });

  // Factory constructor to create Banner from JSON
  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: json['_id'],
      title: json['title'],
      image: json['image'],
      link: json['link'],
      isActive: json['isActive'],
    );
  }
}
