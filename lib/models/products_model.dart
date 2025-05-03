class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.description,
  });

  // To map the Product to/from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
