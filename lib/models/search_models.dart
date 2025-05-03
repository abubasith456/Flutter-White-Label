class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
  });
}

class Category {
  final String name;
  final String imageUrl;

  Category({required this.name, required this.imageUrl});
}
