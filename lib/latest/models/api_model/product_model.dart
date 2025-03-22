class Product {
  final String id;
  final String name;
  final String description;

  Product({required this.id, required this.name, required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
