import 'package:demo_app/latest/models/api_model/category_model.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final Category category;
  final int stock;
  final List<String> images;
  final String? offerId;
  final String createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    required this.images,
    this.offerId,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: Category.fromJson(json['category'] ?? {}),
      stock: json['stock'] ?? 0,
      images: List<String>.from(
        (json['images'] as List<dynamic>?)?.isEmpty ?? true
            ? [
              "https://karanzi.websites.co.in/obaju-turquoise/img/product-placeholder.png",
            ]
            : json['images'] ??
                [
                  "https://karanzi.websites.co.in/obaju-turquoise/img/product-placeholder.png",
                ],
      ),
      offerId: json['offerId'],
      createdAt: json['createdAt'] ?? '',
    );
  }
}
